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

config :bank_api, BankApiWeb.Guardian,
  issuer: "bank_api",
  secret_key: "12VuT/D0iq7sLoU/4XU8AfEV+kdcMJ9qJauA00zsiwmVIKn5+hhny7v6dOZuGY5Q"

config :bank_api, BankApiWeb.AuthAccessPipeline,
  module: BankApiWeb.Guardian,
  error_handler: BankApiWeb.AuthErrorHandler

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
