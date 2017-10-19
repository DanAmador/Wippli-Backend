defmodule TelegramBot.FlowFsm do
  alias WippliBackend.Wippli
  alias TelegramBot.Cache
  alias WippliBackend.Wippli.Zone
  alias TelegramBot.Fsm
  #alias WippliBackend.Accounts
  # Function purgatory
  #  defstate ask_value do
  #    defevent update_db(value), data: data do
  #      key = data[:to_edit]
  #      update_params = Map.new([{key, value}])
  #      Accounts.get_simple_user_by_telegram_id(data[:telegram_id]) |> Accounts.update_user(update_params)
  #      next_state(:polling, get_user_info(data[:telegram_id]))
  #    end
  #  end

  # Shows the possible events a single state could have


  @possible_events %{
    polling: [:ev_edit_info, :goto_zone_register],
    zone_register: [:ev_join_zone],
    ask_password: [:ev_zone_joined],
    ask_value: [:ev_update_db],
    all: [:return_to_polling]
  }

  def new(telegram_id) do
    %Fsm{state: :polling, data: get_user_info(telegram_id), events: @possible_events[:polling]}
  end

  def get_events_by_arity(arity) do
    function_arity_map = __MODULE__.__info__(:functions)
    Enum.filter(get_all_events(), fn(event) -> function_arity_map[event] == arity + 1 end)
  end

  def get_all_events() do
    @possible_events
    |> Map.values
    |> List.flatten
  end

  def possible_events_from_state(state) do
    @possible_events[state]
  end

  defp get_user_info(telegram_id) do
    %{telegram_id: telegram_id, db_id: Cache.get_value(:telegram2dbid, telegram_id)}
  end

  def next_state(fsm, new_state) do
     Map.put(fsm, :state, new_state)
  end

  def next_state(fsm, new_state, {key, value}) do
    Map.put(fsm, key, value) |> next_state(new_state)
  end

  defp join_zone_db(zone_id, user_id, password) do
    IO.inspect "in join zone db"
    with{:ok, _} <- Wippli.join_zone(zone_id,user_id, password) do
      IO.inspect "zone exists madafaka and joooined"
      {:message, "Successfully joined zone"}
    else
      _ ->
        IO.inspect "zone don't exist :( "
      {:message,"Error while trying to join zone"}
    end
  end

  #Global error handler to return to the default state
  def return_to_polling(fsm) do
    next_state(fsm, :polling, get_user_info(fsm.data[:telegram_id]))
  end

  #Polling state
  def ev_edit_info(fsm, key) do
    next_state(fsm, :ask_value, {:to_edit,  [{String.to_atom(key)}]})
  end

  def goto_zone_register(fsm) do
    next_state(fsm, :zone_register)
  end

  def ev_join_zone(fsm, zone_id)  do
    with %Zone{} = zone <- Wippli.get_simple_zone!(zone_id) do
      IO.inspect(zone)
      if zone.password == nil do
        IO.inspect "zone don't have p word, yop "
        next_state(fsm, :join_zone, join_zone_db(zone_id, fsm.data[:db_id], nil))
      else
        IO.inspect("zone has a fucking password")
        next_state(fsm, :ask_password)
      end
    else
      _ ->
        IO.inspect "Zone doesn't exit"
        next_state(fsm, :polling, {:message, "Zone doesn't exist"})
    end
  end

  #Ask Password state
  def join_zone(fsm, password)  do
    data = fsm.data
    next_state(fsm, :return_to_polling, join_zone_db(data[:to_join], data[:db_id], password))
  end

end
