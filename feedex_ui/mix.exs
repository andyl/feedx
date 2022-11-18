defmodule FeedexUi.MixProject do
  use Mix.Project

  def project do
    [
      app: :feedex_ui,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      xref: [exclude: [FeedexCore.Api.SubTree]], 
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {FeedexUi.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.7"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_live_view, "~> 0.15.0"},
      {:floki, ">= 0.27.0", only: :test},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:phx_gen_auth, "~> 0.6", only: [:dev], runtime: false},
      {:telemetry_metrics, "~> 0.4"},
      {:ecto_psql_extras, "~> 0.2"},
      {:phx_tailwind_generators, "~> 0.1.6"},
      {:feedex, in_umbrella: true},
      {:feedex_core, in_umbrella: true},
      {:feedex_job, in_umbrella: true},
      {:surface, "~> 0.2"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:pets, path: "~/src/pets"},
      # {:phoenix_live_editable, github: "andyl/phoenix_live_editable", sparse: "apps/phoenix_live_editable"},
      {:phoenix_live_editable, path: "~/src/phoenix_live_editable/apps/phoenix_live_editable"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "cmd npm install --prefix assets"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
