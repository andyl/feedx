defmodule FeedexCore.Repo do
  use Ecto.Repo,
    otp_app: :feedex_core,
    adapter: Ecto.Adapters.Postgres
end
