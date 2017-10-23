defmodule TelegramBot.Commands.Outside do
  alias TelegramBot.FsmServer
  alias TelegramBot.FlowFsm
  alias WippliBackend.Accounts
  alias WippliBackend.Accounts.User
  use TelegramBot.Commander


  defp pid_from_id(id), do: id  |> FsmServer.pid_or_create
  defp pid_from_update(%Model.Update{callback_query: callback}) when callback != nil, do: callback.from.id |> pid_from_id
  defp pid_from_update(%Model.Update{message: message}), do: message.from.id |> pid_from_id

  defp process_fsm_event( event, [pid | _] = params) do
    state = FsmServer.state(pid)
    if Enum.member?(FlowFsm.possible_events_from_state(state) ++ FlowFsm.possible_events_from_state(:all), event) do
      apply(FsmServer, event, params)
    else
      IO.inspect "event not permitted "
      IO.inspect(FlowFsm.possible_events_from_state(state))
    end
  end

  def update_zone(pid, data, update) do
    if Integer.parse(data) != :error do
      {zone_id, _ } = Integer.parse(data)
      process_fsm_event(:ev_join_zone, [pid, zone_id])
      FsmServer.message(pid, "Error finding zone")
    else
      process_fsm_event(:return_to_polling, [pid])
      FsmServer.message(pid, "Please enter a valid zone")
    end
  end

  def update_value(pid, new_value) do
    to_edit = FsmServer.to_edit(pid)
    data = FsmServer.data(pid)
    with %User{} = user <- Accounts.get_simple_user!(data[:db_id]) do
      if to_edit != nil and is_atom(to_edit) do
        Accounts.update_user(user, %{to_edit => new_value})
        process_fsm_event(:ev_update_user, [pid, to_edit])
        FsmServer.message(pid, "Couldn't update correctly, try later")
      else
        FsmServer.message(pid, "Error updating " <> to_string(to_edit))
      end
    else
      _ -> FsmServer.message(pid, "User doesn't exist")
    end
  end

  def join_zone(update, pid, pass) do
    process_fsm_event(:ev_join_zone_with_pass, [pid,pass])
    FsmServer.message(pid, "Error joining zone")
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
      _ -> :ok
    end
  end

  def return_to_polling(pid) do
    process_fsm_event(:return_to_polling, [pid])
  end
end
