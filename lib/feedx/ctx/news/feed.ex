defmodule Feedx.Ctx.News.Feed do
  @moduledoc """
  Feed DataModel.
  """
  use Ecto.Schema
  alias Feedx.Ctx.News
  import Ecto.Changeset

  schema "feeds" do
    field(:url, :string)
    field(:sync_count, :integer)
    timestamps(type: :utc_datetime)

    has_many :posts, News.Post
  end

  def changeset(feed, attrs) do
    required_fields = [:url]
    optional_fields = []

    feed
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:url)
  end

  def new_changeset do
    changeset(%News.Feed{}, %{})
  end
end
