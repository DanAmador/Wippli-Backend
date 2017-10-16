defmodule TelegramBot.Commands do
  use TelegramBot.Router
  use TelegramBot.Commander
  alias TelegramBot.Cache
  alias TelegramBot.FsmServer
  alias TelegramBot.FlowFsm
  #  alias TelegramBot.Commands.Outside

  defp process_fsm_event( event, [pid | data] = params) do
    possible_events = pid |> FsmServer.state |> FlowFsm.possible_events_from_state
    IO.inspect(possible_events)
    if Enum.member?(possible_events, event) do
      Logger.log :info, "Applying " <> to_string(event) <> " to user " <> pid
      apply(FsmServer, event, params)
    else
    end
  end

  defp advance_fsm(update, event) do
    id = to_string(update.callback_query.from.id)
    process_fsm_event(event, [ FsmServer.pid_or_create(id)])
  end

  defp advance_fsm(update, event, data) do
    id = to_string(update.message.from.id)
    process_fsm_event(event, [FsmServer.pid_or_create(id), data])
  end

  command "/start" do
    send_message("shit boi")
  end
  callback_query_command "options" do
    Logger.log :info, "Callback Query Command /options"
    case update.callback_query.data do
      "/options join_zone" ->
        advance_fsm(update,:join_zone)
        send_message "Type the zone id", reply_markup: %Model.ForceReply{force_reply: true}
        answer_callback_query text: "TODO JOIN ZONE LOGIC"
      "/options songs_in_zone" ->
        answer_callback_query text: "TODO SHOW SONGS IN ZONE"
      "/options request_song" ->
        answer_callback_query text: "TODO request song query"
      "/options edit_info" ->
        answer_callback_query text: "TODO UPDATE USER INFO"
    end
  end

  # Fallbacks
  callback_query do
    Logger.log :warn, "Did not match any callback query"
    answer_callback_query text: "Test"
  end


  message do
    Logger.log :warn, "Did not match the message"

    {:ok, _} = send_message "What do you want to do?",
      # See also: https://hexdocs.pm/nadia/Nadia.Model.InlineKeyboardMarkup.html
      reply_markup: %Model.InlineKeyboardMarkup{
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
  end
end
