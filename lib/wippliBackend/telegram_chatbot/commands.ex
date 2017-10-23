defmodule TelegramBot.Commands do
  use TelegramBot.Router
  use TelegramBot.Commander
  alias TelegramBot.FsmServer
  alias TelegramBot.FlowFsm
  alias TelegramBot.Commands.Outside, as: Out
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

  callback_query_command "options" do
    Logger.log :info, "Callback Query Command /options"
    case update.callback_query.data do
      "/options join_zone" ->
        Out.advance_fsm(update, :goto_zone_register)
        send_message "What's the zone id? ", reply_markup: %Model.ForceReply{force_reply: true}
      "/options songs_in_zone" ->
        answer_callback_query text: "TODO SHOW SONGS IN ZONE"
      "/options request_song" ->
        answer_callback_query text: "TODO request song query"
      "/options edit_info" ->
        answer_callback_query text: "TODO UPDATE USER INFO"
    end
  end

  reply do
    {pid, state} = Out.pid_and_state_from_update(update)
    text = update.message.text
    case  state do
      :zone_register ->
        Out.update_zone(pid, text, update) |> send_message
        Out.post_action(update, pid)
      :ask_password ->
        Out.join_zone(update, pid, text) |> send_message
      _ -> send_message "not doing anything?"
    end
  end


  message do
    Logger.log :warn, "Did not match the message"
    {pid, state} = Out.pid_and_state_from_update(update)
    send_message to_string(state)
    case  state do
      :zone_register ->
        Out.update_zone(pid, update.message.text, update) |> send_message
        Out.post_action(update, pid)
      _-> send_message "What do you want to do?",
      reply_markup: @default_menu
    end
  end
end
