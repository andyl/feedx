defmodule FeedexJob.MixProject do
  use Mix.Project

  def project do
    [
      app: :feedex_job,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {FeedexJob.Application, []},
      extra_applications: [:logger, :runtime_tools, :timex]
    ]
  end

  defp deps do
    [
      {:fc_rss, in_umbrella: true},
      {:feedex, in_umbrella: true},
      {:feedex_core, in_umbrella: true},
      # {:phoenix_pubsub, "~> 2.0"},
      {:quantum, "~> 3.3"},
      {:timex, "~> 3.0"},
    ]
  end
end
