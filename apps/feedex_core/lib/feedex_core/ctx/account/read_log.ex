defmodule FeedexCore.Ctx.Account.ReadLog do
  @moduledoc """
  FeedLog DataModel.
  """

  use Ecto.Schema

  alias FeedexCore.Ctx.{Account, News}
  import Ecto.Changeset

  schema "read_logs" do
    belongs_to :user    , Account.User
    belongs_to :folder  , Account.Folder
    belongs_to :register, Account.Register
    belongs_to :post    , News.Post
  end

  def changeset(read_log, attrs) do
    required_fields = [:user_id, :folder_id, :register_id, :post_id]
    optional_fields = []

    read_log
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:duplicate_log, name: :unique_read_log)
  end
end
