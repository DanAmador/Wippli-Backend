defmodule Wippli.UserFactory do
  alias WippliBackend.Accounts.User
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          nickname: "Metrosexual Fruitcake",
          phone: "555555555",
          id: 1,
          telegram_id: "12315"
        }
      end
    end
  end
end
