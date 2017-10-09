defmodule TelegramBot.Commands do
  use TelegramBot.Router
  use TelegramBot.Commander

  alias TelegramBot.Commands.Outside
  # Fallbacks


  message do
    Logger.log :warn, "Did not match the message"

    send_message "Sorry, I couldn't understand you"
  end
end
