defmodule FcFinch.Application do
  @moduledoc false

  use Application

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start, []},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def start() do
    start(:x, :y)
  end

  @impl true
  def start(_type, _args) do
    children = [
      {Finch, name: FcFinch.App}
    ]

    opts = [strategy: :one_for_one, name: FcFinch.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
