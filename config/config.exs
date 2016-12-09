# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :meta_dashboard, MetaDashboard.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ne2mLpvVDSrC0pDgwtfgaB9oeglfrnFJAHlHFhs+kI2cTHJpgtuLqRXPwheZlIs4",
  render_errors: [view: MetaDashboard.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MetaDashboard.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :json_hyperschema_client_builder, Heroku,
  access_token: System.get_env("HEROKU_ACCESS_TOKEN")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
