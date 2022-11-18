import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :feedx, Feedx.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "feedx_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :feedx, FeedxWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "DA9y9oRrwesl4cj92zdFNU+VcJag81pMl/uGBSS00QgR+E2oRJnDvWu3ADiTnEK/",
  server: false

# In test we don't send emails.
config :feedx, Feedx.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only errors during test
config :logger, level: :error

# Print only warnings and errors during test
# config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
