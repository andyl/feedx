defmodule Feedx.MixProject do
  use Mix.Project

  def project do
    [
      app: :feedx,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Feedx.Application, []},
      extra_applications: extra_apps()
    ]
  end

  # Specifies extra_applications per environment.
  defp extra_apps do
    case Mix.env() do
      :test -> [:logger, :runtime_tools]
      _ -> [:logger, :runtime_tools, :os_mon]
    end
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Web Server
      # {:bandit, "~> 0.6"},
      {:plug_cowboy, "~> 2.0"},
      # Web UI
      {:swoosh,                 "~> 1.3"},
      {:phoenix,                "~> 1.7.0-rc.0", override: true},
      {:phoenix_ecto,           "~> 4.4"},
      {:phoenix_live_dashboard, "~> 0.7"},
      {:phoenix_html,           "~> 3.0"},
      {:phoenix_live_view,      "~> 0.18"},
      {:phoenix_live_reload,    "~> 1.2", only: :dev},
      {:heroicons,              "~> 0.5"},
      {:gettext,                "~> 0.20"},
      {:esbuild,                "~> 0.5", runtime: Mix.env() == :dev},
      {:tailwind,               "~> 0.1.8", runtime: Mix.env() == :dev},
      # Testing
      {:ex_machina, "~> 2.7"},
      {:floki,      ">= 0.30.0", only: :test},
      # Util
      {:bcrypt_elixir, "~> 3.0"},
      {:pbkdf2_elixir, "~> 2.0"},
      {:modex, path: "~/src/modex"},
      # Repo
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      # Telemetry
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller,  "~> 1.0"},
      {:ecto_psql_extras,  "~> 0.6"},
      # Fc
      {:finch, "~> 0.13"},
      {:jason, "~> 1.2"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
