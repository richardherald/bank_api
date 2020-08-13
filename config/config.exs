# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bank_api,
  ecto_repos: [BankApi.Repo]

# Configures the endpoint
config :bank_api, BankApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bjnOSGI3kxxMXCStKSc5bX3/Y61igafGdE4ohwmbj/hdDIFa8uDmAExOWAK3j24+",
  render_errors: [view: BankApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BankApi.PubSub,
  live_view: [signing_salt: "ZlB1/ZYV"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :bank_api, BankApiWeb.GuardianUser,
  issuer: "bank_api",
  secret_key: "eygyjfmkGPPlVy8P/+5fe+LnHBYO1NOjctzvftQeU5cPbUJZW1iPHNvRU0pHWDXs"

config :bank_api, BankApiWeb.AuthUserAccessPipeline,
  module: BankApiWeb.GuardianUser,
  error_handler: BankApiWeb.AuthErrorHandler

config :bank_api, BankApiWeb.GuardianAdmin,
  issuer: "bank_api_admin",
  secret_key: "SW9vfiao+YG2Pn5Dt/JTWm87NZTRSV9iMVBmWXEaIZE7mKSmKBKYYiNKrSmyFNdu"

config :bank_api, BankApiWeb.AuthAdminAccessPipeline,
  module: BankApiWeb.GuardianAdmin,
  error_handler: BankApiWeb.AuthErrorHandler

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
