defmodule Wippli.ZoneFactory do
  alias WippliBackend.Wippli.Zone
  defmacro __using__(_opts) do
    quote do
      def zone_factory do
        %Zone{
          id: 1,
          created_by: 1,
          password: "password"
        }
      end
    end
  end
end
