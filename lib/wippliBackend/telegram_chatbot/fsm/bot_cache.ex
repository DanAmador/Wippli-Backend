defmodule TelegramBot.Cache  do
  use ExActor.GenServer

  defstart start(cache_name, timeout_after \\ :infinity),
    gen_server_opts: [name: cache_name]
  do
    timeout_after(timeout_after)
    :ets.new(cache_name, [:named_table, :set, :protected])
    initial_state(cache_name)
  end

  def get(cache_name, key) do
    case :ets.lookup(cache_name, key) do
      [{^key, value}] -> value
      [] -> nil
    end
  end

  def get_or_create(cache_name, key, new) do
    case get(cache_name, key) do
      nil -> server_get_or_create(cache_name, key, new)
      existing -> existing
    end
  end

  defcallp server_get_or_create(key, new), state: cache_name do
    case get(cache_name, key) do
      nil ->
        store(cache_name, key, new)
        # Makes a distributed call to all other nodes
        set(Node.list, cache_name, key, new)
        new

      existing -> existing
    end
    |> reply
  end

  # Distributed setter - stores to all nodes in the cluster
  defmulticall set(key, value), state: cache_name do
    store(cache_name, key, value)
    reply(:ok)
  end

  defp store(cache_name, key, value) do
    :ets.insert(cache_name, {key, value})
  end

  # Stops the server on timeout message
  defhandleinfo :timeout, do: stop_server(:normal)
  defhandleinfo _, do: noreply
end
