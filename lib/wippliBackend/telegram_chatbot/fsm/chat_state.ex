defmodule TelegramBot.FlowFsm do
  use Fsm, initial_state: :start
  alias WippliBackend.Accounts
  alias WippliBackend.Wippli
  alias TelegramBot.Cache
  alias WippliBackend.Wippli.Zone
  # Function purgatory
  defstate ask_value do
    defevent update_db(value), data: data do
      key = data[:to_edit]
      update_params = Map.new([{key, value}])
      Accounts.get_simple_user_by_telegram_id(data[:telegram_id]) |> Accounts.update_user(update_params)
      next_state(:polling, get_user_info(data[:telegram_id]))
    end
  end


  # Shows the possible events a single state could have
  @possible_events %{
    start: [:start_polling],
    polling: [:ev_edit_info, :goto_zone_register],
    zone_register: [:ev_join_zone],
    ask_password: [:ev_zone_joined],
    ask_value: [:ev_update_db],
    all: [:return_to_polling]
  }

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

  defp join_zone_db(data, zone_id, user_id, password) do
    IO.inspect "in join zone db"
    with{:ok, _} <- Wippli.join_zone(zone_id,user_id, password) do
      IO.inspect "zone exists madafaka and joooined"
      data |> Map.put_new(:message, "Successfully joined zone")
    else
      _ ->

        IO.inspect "zone don't exist :( "
        data |> Map.put_new(:message,"Error while trying to join zone")
    end
  end

  #Global error handler to return to the default state 
  defevent return_to_polling, data: data do
    next_state(:polling, get_user_info(data[:telegram_id]))
  end

  defstate start do
    defevent start_polling(id) do
      next_state(:polling, get_user_info(id))
    end
  end

  defstate polling do
    defevent ev_edit_info(key), data: data do
      new_data = data |> Map.put_new(:to_edit, [{String.to_atom(key)}] )
      next_state(:ask_value, new_data)
    end

    defevent goto_zone_register, data: data do
      next_state(:zone_register, data)
    end
  end

  defstate zone_register do
    defevent ev_join_zone(zone_id), data: data do
      IO.inspect "I'm in ev join zone"
      next_state(:ask_value, new_data)
      IO.inspect data
      #     IO.inspect zone_id
 #     with %Zone{} = zone <- Wippli.get_simple_zone!(zone_id) do
 #       IO.inspect(zone.password)
 #       if zone.password == nil do
 #         IO.inspect "zone don't have p word, yop "
 #         next_state(:join_zone, join_zone_db(data,zone_id, data[:db_id], nil))
 #       else
 #         next_state(:polling, data )#|> Map.put_new(:to_join, zone_id))
 #       end
 #     else
 #       _ -> next_state(:polling, data |> Map.put_new(:message, "Zone doesn't exist"))
 #     end

    end
  end

  defstate ask_password  do
    defevent join_zone(password), data: data  do
      next_state(:return_to_polling, join_zone_db(data, data[:to_join],data[:db_id], password))
    end
  end
 end
