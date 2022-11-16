defmodule FcRss.MixProject do
  use Mix.Project

  def project do
    [
      app: :fc_rss,
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

  def application do
    [
      extra_applications: [
        :elixir_feed_parser, 
        :logger
      ]
    ]
  end

  defp deps do
    [
      {:fc_tesla, in_umbrella: true},
      {:elixir_feed_parser, github: "andyl/elixir-feed-parser"},
      {:exvcr, "~> 0.12", only: [:test]}
    ]
  end
end
