defmodule FcFinch.MixProject do
  use Mix.Project

  def project do
    [
      app: :fc_finch,
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
      mod: {FcFinch.Application, []}
    ]
  end

  defp deps do
    [
      {:finch, "~> 0.6"},
      {:jason, "~> 1.2"}
    ]
  end
end
