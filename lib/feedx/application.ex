defmodule Feedx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FeedxWeb.Telemetry,
      # Start the Ecto repository
      Feedx.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Feedx.PubSub},
      # Start Finch
      {Finch, name: Feedx.Finch},
      # Start the Endpoint (http/https)
      FeedxWeb.Endpoint
      # Start a worker by calling: Feedx.Worker.start_link(arg)
      # {Feedx.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Feedx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FeedxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
