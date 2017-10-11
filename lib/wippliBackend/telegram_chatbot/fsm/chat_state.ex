defmodule TelegramBot.FsmServer do
  alias TelegramBot.FlowFsm
  alias TelegramBot.Cache


  def create(id) do
    {_, _} = Cache.start(:id2pid)
    pid = FlowFsm.new(initial_data: %{id: id})
    Cache.get_or_create(:id2pid,id, pid)
  end
end


defmodule TelegramBot.FlowFsm do
  use ExActor.GenServer
  use Fsm, initial_state: :start
  alias WippliBackend.Accounts
  #use ExActor.Responders

  defstate start do
    defevent start_polling(id), data: data do
      new_data = %{} |> Map.put(:telegram_id,  id)
      next_state(:polling, new_data)
    end
  end

  defstate polling do
    defevent edit_info(key), data: data do
      new_data = data |> Map.put_new(:to_edit, [{String.to_atom(key)}] )
      next_state(:ask_value, new_data)
    end
  end


  defstate ask_value do
    defevent update_db(value), data: data do
      params = data[:to_edit]
      update_params = Map.new([{elem(params,0), elem(params,1)}])
      Accounts.get_simple_user_by_telegram_id(data[:telegram_id]) |> Accounts.update_user(update_params)
      new_data = %{} |> Map.put(:telegram_id, data[:telegram_id])
      next_state(:polling, new_data)
    end
  end
 end
