# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :betsnap,
  ecto_repos: [Betsnap.Repo],
  generators: [timestamp_type: :utc_datetime],
  api_key: System.get_env("API_KEY"),
  api_url: System.get_env("API_URL")

# Configures the endpoint
config :betsnap, BetsnapWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: BetsnapWeb.ErrorHTML, json: BetsnapWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Betsnap.PubSub,
  live_view: [signing_salt: "epQBZzFM"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :betsnap, Betsnap.Mailer, adapter: Swoosh.Adapters.Local

config :betsnap, Oban,
  repo: Betsnap.Repo,
  queues: [default: 2, bets_validation: 2],
  plugins: [
    {Oban.Plugins.Cron,
      crontab: [
        {"*/15 * * * *", Betsnap.Workers.ProcessorWorker, args: %{name: "ProcessorWorker"}}
      ]
    }
  ]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  betsnap: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  betsnap: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
