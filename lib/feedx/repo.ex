defmodule Feedx.Repo do
  use Ecto.Repo,
    otp_app: :feedx,
    adapter: Ecto.Adapters.Postgres
end
