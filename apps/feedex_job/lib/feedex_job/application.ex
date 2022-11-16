defmodule FeedexJob.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      FeedexJob.Scheduler
    ]

    opts = [strategy: :one_for_one, name: FeedexJob.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
