# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sjc,
  ecto_repos: [Sjc.Repo],
  game_timeout: 3_600_000,
  round_timeout: 60_000

# Configures the endpoint
config :sjc, SjcWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Xcwjxx4wSQrs+PCHDvLFp81uTCUjYHdQ0lNhtJ+pXDjF3vUTJ1Al8v+qXAguY5QE",
  render_errors: [view: SjcWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Sjc.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
