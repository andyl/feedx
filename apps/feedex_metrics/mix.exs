defmodule FeedexMetrics.MixProject do
  use Mix.Project

  def project do
    [
      app: :feedex_metrics,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {FeedexMetrics.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # ----- umbrella apps
      {:feedex_ui, in_umbrella: true}, 
      {:feedex_core, in_umbrella: true},
      # ----- telemetry support
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:telemetry_influxdb, "~> 0.2.0"}
    ]
  end
end
