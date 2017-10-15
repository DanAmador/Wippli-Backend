defmodule TelegramBot.Cache do
  use Nebulex.Cache, otp_app: :wippliBackend

  def get_or_create(table, key, value) do
    real_key = get_cache_key(table,key)
    cond do
      has_key? real_key -> get(real_key)
      true -> set(real_key, value, return: :value)
    end
  end

  def get_value(table, key) do
    get(get_cache_key(table, key))
  end

  defp get_cache_key(table, key), do: to_string(table) <> "_"<> key
end
