defmodule TelegramBot.Commands.Outside do
  alias TelegramBot.FsmServer
  alias TelegramBot.FlowFsm
  use TelegramBot.Commander


  defp pid_from_id(id), do: id  |> FsmServer.pid_or_create
  defp pid_from_update(%Model.Update{callback_query: callback}) when callback != nil, do: callback.from.id |> pid_from_id
  defp pid_from_update(%Model.Update{message: message}), do: message.from.id |> pid_from_id

  defp process_fsm_event( event, [pid | _] = params) do
    if Enum.member?(FsmServer.events(pid), event) or Enum.member?(FlowFsm.possible_events_from_state(:all), event) do
      apply(FsmServer, event, params)
      IO.inspect "new state: " <> to_string(FsmServer.state(pid))
    end
  end

  def update_zone(pid, data, update) do
    if Integer.parse(data) != :error do
      {zone_id, _ } = Integer.parse(data)
      process_fsm_event(:ev_join_zone, [pid, zone_id])
      Map.get(FsmServer.fsm(pid), :message, "Error getting zone")
    else
      process_fsm_event(:return_to_polling, [pid])
      "Please enter a valid zone"
    end
  end

  def join_zone(update, pid, pass) do
    process_fsm_event(:ev_join_zone_with_pass, [pid,pass])
    Map.get(FsmServer.fsm(pid), :message, "Error joining zone")
  end

  def pid_and_state_from_update(update) do
    pid = pid_from_update(update)
    {pid, FsmServer.state(pid)}
  end

  def advance_fsm(update, event) do
    process_fsm_event(event, [ pid_from_update(update)])
  end

  def advance_fsm(update, event, data) do
    process_fsm_event(event, [pid_from_update(update), data])
  end

  def post_action(update, pid) do
    fsm = FsmServer.fsm(pid)

    case fsm.state do
      :ask_password -> send_message "Enter password", reply_markup: %Model.ForceReply{force_reply: true}
      _ -> send_message "default"
    end
  end
end
