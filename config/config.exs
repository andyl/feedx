# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :feedx,
  ecto_repos: [Feedx.Repo]

# Configures the endpoint
config :feedx, FeedxWeb.Endpoint,
  # adapter: Bandit.PhoenixAdapter,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: FeedxWeb.ErrorHTML, json: FeedxWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Feedx.PubSub,
  live_view: [signing_salt: "57/ietvK"],
  live_editable: [ple_renderer: Phoenix.Editable.Renderer.Tailwind3]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :feedx, Feedx.Mailer, adapter: Swoosh.Adapters.Local

# ----- FeedxJob

config :feedx_job,
  env: Mix.env()

config :feedx_job, FeedxJob.Scheduler,
  jobs: [
    # {"*/15 * * * *",   fn -> System.cmd("rm", ["/tmp/tmp_"]) end},
    # {"0 18-6/2 * * *", fn -> :mnesia.backup('/var/backup/mnesia') end},
    # {"@daily",         {Backup, :backup, []}}
    # {"* * * * *",      {IO, :puts, ["CRON JOB"]}}
    # {"* * * * *",        {FeedexCore.Metrics.AppPoller, :post_counts, []}},
    {"*/2 * * * *",      {FeedxJob, :sync_next, []}}
  ]

# ----- Esbuild

config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.1.8",
  default: [
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
