defmodule TelegramBot.FsmServer do
  alias TelegramBot.FlowFsm
  alias TelegramBot.Cache
  alias WippliBackend.Accounts
  use ExActor.GenServer
  @null_arity_events [:return_to_polling, :update_zone_for_user]
  @one_arity_events [:start_polling, :edit_info, :join_zone, :update_db]


  defstart start_link, do: initial_state(FlowFsm.new)

  def create(id) do
    {:ok, pid} = start_link()
    Cache.get_or_create(:teleid2pid, id, pid)
    user = Accounts.get_or_create_user_by_telegram_id(id)
    Cache.get_or_create(:telegram2dbid, id, user.id)
    pid
  end

  for event <- @null_arity_events do
    defcast unquote(event), state: fsm do
      FlowFsm.unquote(event)(fsm)
      |> new_state
    end
  end

  for event <- @one_arity_events do
    defcall unquote(event)(data), state: fsm do
      FlowFsm.unquote(event)(fsm, data)
      |> reply
    end
  end

  defcall state, state: fsm, do: reply(FlowFsm.state(fsm))
  defcall data, state: fsm, do: reply(FlowFsm.data(fsm))
end

