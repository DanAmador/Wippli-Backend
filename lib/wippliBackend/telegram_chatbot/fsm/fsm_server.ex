defmodule TelegramBot.FsmServer do
  alias TelegramBot.FlowFsm
  alias TelegramBot.Cache
  alias WippliBackend.Accounts
  use ExActor.GenServer

  defstart start_link(id), do: initial_state(create_fsm(id))

  defp create(id) do
    {:ok, pid} = start_link(id)
    Cache.get_or_create(:teleid2pid, id, pid)
    user = Accounts.get_or_create_user_by_telegram_id(id)
    Cache.get_or_create(:telegram2dbid, id, user.id)
    pid
  end

  defp create_fsm(id) do
    FlowFsm.new
    |> FlowFsm.start_polling(id)
  end

  def pid_or_create(id) do
    pid = Cache.get_value(:teleid2pid, id)
    case  pid do
      nil -> create(id)
      _ -> pid
    end
  end

  for event <- FlowFsm.get_events_by_arity(0) do
    defcast unquote(event), state: fsm do
      FlowFsm.unquote(event)(fsm)
      |> new_state
    end
  end

  for event <- FlowFsm.get_events_by_arity(1) do
    defcall unquote(event)(data), state: fsm do
      FlowFsm.unquote(event)(fsm, data)
      |> new_state
    end
  end

  defcall event_options, state: fsm, do: reply(FlowFsm.possible_events_from_state(FlowFsm.state(fsm)))
  defcall state, state: fsm, do: reply(FlowFsm.state(fsm))
  defcall data, state: fsm, do: reply(FlowFsm.data(fsm))
end
