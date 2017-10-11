defmodule TelegramBot.FsmTest do
  use ExUnit.Case
  alias TelegramBot.FlowFsm
  test "initial state is start" do
    assert FlowFsm.new.state == :start
  end


  test "test start polling flow " do

    fsm = FlowFsm.new |> FlowFsm.start_polling(1)

    assert fsm.state == :polling
    assert fsm.data == %{telegram_id: 1}
  end
end
