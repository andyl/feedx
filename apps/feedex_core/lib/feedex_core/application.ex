defmodule FeedexCore.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      FeedexCore.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: FeedexCore.Supervisor)
  end
end
