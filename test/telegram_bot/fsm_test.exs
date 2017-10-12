defmodule TelegramBot.FsmTest do
  use ExUnit.Case
  alias TelegramBot.FlowFsm
  alias TelegramBot.FsmServer
  import Wippli.Factory

  test "initial state is start" do
    assert FlowFsm.new.state == :start
  end

  setup  do

    insert(:user)
    FsmServer.create(1)
  end


  test "test start polling flow " do

    fsm = FlowFsm.new |> FlowFsm.start_polling(1)

    assert fsm.state == :polling
    assert fsm.data == %{telegram_id: 1, db_id: 1 }
  end
end
