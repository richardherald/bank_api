use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :bank_api, BankApi.Repo,
  username: "herald",
  password: "123456",
  database: "bank_api_test5#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("PG_HOSTNAME") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bank_api, BankApiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :argon2_elixir, t_cost: 2, m_cost: 12
