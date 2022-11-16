defmodule Feedx.Ctx.Account.RegFeed do
  @moduledoc """
  A virtual data-model - used for feed creation.
  """
  use Ecto.Schema
  alias Feedx.Ctx.Account
  import Ecto.Changeset

  embedded_schema do
    field(:folder_id, :integer)
    field(:name, :string)
    field(:url, :string)
  end

  def changeset(reg_feed, attrs) do
    required_fields = [:url]
    optional_fields = [:name]

    reg_feed
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> validate_length(:name, min: 3, max: 10)
    |> validate_length(:url, min: 6)
  end

  def new_changeset do
    changeset(%Account.RegFeed{}, %{})
  end
end
