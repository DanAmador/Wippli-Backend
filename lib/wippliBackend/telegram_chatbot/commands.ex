defmodule TelegramBot.Commands do
  use TelegramBot.Router
  use TelegramBot.Commander
  alias TelegramBot.FsmServer
  alias TelegramBot.FlowFsm
  #  alias TelegramBot.Commands.Outside

  defp pid_from_id(id), do: id  |> FsmServer.pid_or_create
  defp pid_from_update(%Model.Update{callback_query: callback}) when callback != nil, do: callback.from.id |> pid_from_id
  defp pid_from_update(%Model.Update{message: message}), do: message.from.id |> pid_from_id

  defp process_fsm_event( event, [pid | _] = params) do
    possible_events = pid |> FsmServer.state |> FlowFsm.possible_events_from_state
    if Enum.member?(possible_events, event) do
      apply(FsmServer, event, params)
      IO.inspect "new state: " <> to_string(FsmServer.state(pid))
    end
  end

  defp update_zone(pid, data, update) do
    if Integer.parse(data) != :error do
      {zone_id, _ } = Integer.parse(data)
      process_fsm_event(:ev_join_zone, [pid, zone_id])
      Map.get(FsmServer.data(pid), :message, "Error getting zone")
    else
      "Please enter a valid zone"
    end
  end

  defp pid_and_state_from_update(update) do
    pid = pid_from_update(update)
    {pid, FsmServer.state(pid)}
  end

  defp advance_fsm(update, event) do
    process_fsm_event(event, [ pid_from_update(update)])
  end

  defp advance_fsm(update, event, data) do
    process_fsm_event(event, [pid_from_update(update), data])
  end

  command "/start" do
    send_message("shit boi")
    answer_callback_query ("shit boooooooi")
  end
  callback_query_command "options" do
    Logger.log :info, "Callback Query Command /options"
    case update.callback_query.data do
      "/options join_zone" ->
        advance_fsm(update, :goto_zone_register)
        send_message "What's the zone id? ", reply_markup: %Model.ForceReply{force_reply: true}
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

  reply do
    {pid, state} = pid_and_state_from_update(update)
    text = update.message.text
    case  state do
      :zone_register ->
        message = update_zone(pid, text, update)
        send_message(FsmServer.state(pid))
      _ -> send_message "not doing anything?"
    end
  end


  message do
    Logger.log :warn, "Did not match the message"
    {_, state} = pid_and_state_from_update(update)
    case  state do
        _-> send_message "What do you want to do?",
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
end
