import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :kanbored, Kanbored.Repo,
  username: "postgres.ltbjxtgcnunlhxzoinye",
  password: "rMv2u$MYU8Ww!C73xcn4E5@ea",
  hostname: "aws-0-sa-east-1.pooler.supabase.com",
  database: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kanbored, KanboredWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "HMQ0FYPQtxeifXh0ByOqYMOyOdT5SutqlwC+erShYvQVVtNloLPDPwVbR6nKukRe",
  server: false

# In test we don't send emails
config :kanbored, Kanbored.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
