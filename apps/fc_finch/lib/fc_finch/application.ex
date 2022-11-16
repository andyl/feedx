defmodule FcFinch.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Finch, name: FcFinch.App}
    ]

    opts = [strategy: :one_for_one, name: FcFinch.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
