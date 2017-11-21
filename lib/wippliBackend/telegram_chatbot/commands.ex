defmodule TelegramBot.Commands do
  use TelegramBot.Router
  use TelegramBot.Commander
  alias TelegramBot.FsmServer
  alias TelegramBot.Commands.Outside, as: Out
  alias WippliBackend.Accounts
  alias WippliBackend.Wippli
  alias WippliBackend.Accounts.User
  alias WippliBackend.Wippli.Participant
  alias WippliBackend.Wippli.RequestHelper

  @moduledoc """
  Provides routing for the Telegram bot using the outside module as a logic helper 
  """

  @default_menu %Model.InlineKeyboardMarkup{
    inline_keyboard: [
      [
        %{
          callback_data: "/options join_zone",
          text: "Zone",
        },
        %{
          callback_data: "/options songs_in_zone",
          text: "Playlist",
        },
        %{
          callback_data: "/options request_song",
          text: "Request",
        },
        %{
          callback_data: "/options edit_info",
          text: "Edit Info",
        },
      ],
      []
    ]
  }

  @options_menu %Model.InlineKeyboardMarkup{
    inline_keyboard: [
      [
        %{
          callback_data: "/edit nickname",
          text: "Nickname",
        },
        %{
          callback_data: "/edit phone",
          request_contact: true,
          text: "Phone",
        },

      ],
      []
    ]
  }


  callback_query_command "vote" do
    Logger.log :info, "Callback Query Command /vote"
    [scope, command, request_id, user_id] = String.split(update.callback_query.data)
    case Enum.join([scope, command], " ")   do
      "/vote true" ->
        Wippli.create_or_update_vote(request_id, user_id, 1)
        answer_callback_query text: "Vote sent!"

      "/vote false" ->
        Wippli.create_or_update_vote(request_id, user_id, -1)
        answer_callback_query text: "Veto sent!"
    end
  end

  callback_query_command "song" do
    Logger.log :info, "Callback Query Command /song"
    [scope, command, zone_id_string, user_id] = String.split(update.callback_query.data)
    zone_id = zone_id_string |> String.to_integer
    case Enum.join([scope, command], " ")   do
      "/song all" ->
        Wippli.get_requests_in_zone(zone_id, 100) |> Out.format_songs(update, user_id)
      "/song unplayed" ->
        Wippli.get_requests_in_zone(zone_id, 0) |> Out.format_songs(update, user_id)
    end
  end

  callback_query_command "edit" do
    Logger.log :info, "Callback Query Command /edit"
    case update.callback_query.data do
      "/edit nickname" ->
        Out.advance_fsm(update, :goto_ask_value, :nickname)
        send_message "What's your new nickname?", reply_markup: %Model.ForceReply{force_reply: true}
      "/edit phone" ->
        Out.advance_fsm(update, :goto_ask_value, :phone)
        send_message "Confirm your contact", reply_markup: %Model.ReplyKeyboardMarkup{
          keyboard: [
            [
              %{
                request_contact: true,
                text: "Send phone"
              }
            ],
          ],
          one_time_keyboard: true
        }
    end
    answer_callback_query text: "Choose what to edit"
  end

  callback_query_command "options" do
    Logger.log :info, "Callback Query Command /options"
    case update.callback_query.data do
      "/options join_zone" ->
        Out.advance_fsm(update, :goto_zone_register)
        answer_callback_query text: "Joining zone"
        send_message "What's the zone id? ", reply_markup: %Model.ForceReply{force_reply: true}
      "/options songs_in_zone" ->
        with %User{participants: %Participant{} = participant }  <- Accounts.get_simple_user_by_telegram_id(update.callback_query.from.id) do
          send_message("Which songs do you wish to see?", reply_markup: %Model.InlineKeyboardMarkup{
                inline_keyboard: [
                  [
                    %{
                      callback_data: "/song all #{to_string(participant.zone_id)} #{to_string(participant.user_id)}" ,
                      text: "All",
                    },
                    %{
                      callback_data: "/song unplayed #{to_string(participant.zone_id)} #{to_string(participant.user_id)}",
                      text: "Unplayed",
                    },

                  ],
                  []
                ]
}

          )
        else
          _ ->
          send_message "Currently not in zone"
        end
      "/options edit_info" ->
        send_message "What do you want to edit?", reply_markup: @options_menu
        answer_callback_query text: "Edit Info"
    end
  end

  reply do
    {pid, state} = Out.pid_and_state_from_update(update)
    case state do
      :zone_register ->
        Out.update_zone(pid, update.message.text, update) |> send_message
        Out.post_action(update, pid)
      :ask_password ->
        Out.join_zone(update, pid, update.message.text) |> send_message
      :ask_value ->
          Out.update_value(pid, update.message.text) |> send_message
      _ -> send_message "not doing anything?"
    end
  end


  contact do
    {pid, state} = Out.pid_and_state_from_update(update)
    to_edit = FsmServer.to_edit(pid)
    if state == :ask_value and to_edit == :phone do
      Out.update_value(pid,  update.message.contact.phone_number) |> send_message
    end
  end

  message do
    Logger.log :warn, "Did not match the message"
    {pid, state} = Out.pid_and_state_from_update(update)
    send_message to_string(state)
    case  state do
      :polling ->
        url = update.message.text
        case RequestHelper.valid_url(url) do
          {:ok, _ } ->
            data = FsmServer.data(pid)
            case Wippli.create_request(data[:db_id], url) do
              {:ok, request} -> send_message "Successfully added <i>#{request.song.title}</i>  to current zone", parse_mode: "html"
              _ -> send_message "Try with a different song!"
            end
          _ -> send_message "What do you want to do?",
          reply_markup: @default_menu
        end
      _ ->
        Out.return_to_polling(pid)
    end
  end
end
