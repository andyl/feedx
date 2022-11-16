defmodule FeedexCore.Ctx.Account.Register do
  @moduledoc """
  Register DataModel.

  A Register is a many-to-many table, joining an `Account.Folder` to a
  `News.Feed`.  The Register concept appears in the code, but is not exposed to
  end-users. (EndUsers see Folders and Feeds)
  """
  use Ecto.Schema
  alias FeedexCore.Ctx.{Account, News}
  import Ecto.Changeset

  schema "registers" do
    field(:name, :string)
    timestamps(type: :utc_datetime)

    has_many   :read_logs, Account.ReadLog
    belongs_to :folder, Account.Folder
    belongs_to :feed, News.Feed
  end

  def changeset(register, attrs) do
    required_fields = [:name]
    optional_fields = [:folder_id]

    register
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name, name: :registers_user_id_name_index)
  end
end
