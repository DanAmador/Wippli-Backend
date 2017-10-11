# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration

config :wippliBackend,
  bot_name: "WippliBot",
  yt_key: "AIzaSyA4dtSq3_tLjwHyVOQjqwt9KS3pOTlM5gQ",
  ecto_repos: [WippliBackend.Repo]

# Configures the endpoint
config :wippliBackend, WippliBackendWeb.Endpoint,
  bot_name: "WippliBot",
  url: [host: "localhost"],
  secret_key_base: "8XCGJ3lEiKbdPvQBU+zeFvbNVoXJQXKWgX3zAx1vn0ubB5225bY2dIXyprO8zYzJ",
  render_errors: [view: WippliBackendWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: WippliBackend.PubSub,
           adapter: Phoenix.PubSub.PG2]
# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :nadia,
  token: "425939657:AAEFOlTnwtGSwdEMKQ0dkVwOAPRsZMQXb-Q"
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
