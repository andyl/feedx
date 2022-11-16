defmodule FeedexUi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: FeedexUi.PubSub},
      # Start the Endpoint (http/https)
      FeedexUi.Endpoint
      # Start a worker by calling: FeedexUi.Worker.start_link(arg)
      # {FeedexUi.Worker, arg}
    ] 

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FeedexUi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FeedexUi.Endpoint.config_change(changed, removed)
    :ok
  end
end
