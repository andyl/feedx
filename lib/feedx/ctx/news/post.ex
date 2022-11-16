defmodule Feedx.Ctx.News.Post do
  @moduledoc """
  Post DataModel.
  """
  use Ecto.Schema
  alias Feedx.Ctx.News
  alias Feedx.Ctx.Account
  import Ecto.Changeset

  schema "posts" do
    field(:exid,    :string)
    field(:title,   :string)
    field(:body,    :string)
    field(:author,  :string)
    field(:link,    :string)
    timestamps(type: :utc_datetime)

    has_many :read_logs, Account.ReadLog
    belongs_to :feed, News.Feed
  end

  def changeset(user, attrs) do
    required_fields = [:exid, :body]
    optional_fields = [:feed_id]

    user
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:uuid)
  end
end
