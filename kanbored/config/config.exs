# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :kanbored,
  ecto_repos: [Kanbored.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :kanbored, KanboredWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: KanboredWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Kanbored.PubSub,
  live_view: [signing_salt: "ZjhVrISr"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :kanbored, Kanbored.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :kanbored, Kanbored.UserManager,
  issuer: "Kanbored",
  secret_key: "b2EGs2cRq81DkaLUrfwDV87UyYh8Zj/gUhu4h+S5UylA6x+N4etzk8FYr/NqDBBSd"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
