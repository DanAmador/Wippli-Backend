defmodule Wippli.RequestFactory do
  alias WippliBackend.Wippli.Request
  defmacro __using__(_opts) do
    quote do
      def request_factory do
        %Request{
          id: 1,
          song_id: 1
        }
      end
    end
  end
end
