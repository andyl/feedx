defmodule FeedexCore.Ctx.Account.Folder do
  @moduledoc """
  Folder DataModel.
  """
  use Ecto.Schema
  alias FeedexCore.Ctx.Account
  import Ecto.Changeset

  schema "folders" do
    field(:name, :string)
    field(:stopwords, :string)
    timestamps(type: :utc_datetime)

    belongs_to :user, Account.User
    has_many :registers, Account.Register
    has_many :read_logs, Account.ReadLog 
    has_many :feeds, through: [:registers, :feeds]
    has_many :posts, through: [:registers, :feeds, :posts]
  end

  def changeset(folder, attrs) do
    required_fields = [:name]
    optional_fields = [:user_id, :stopwords]

    folder
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> validate_length(:name, min: 3, max: 10)
    |> unique_constraint(:name, name: :folder_user_name_index)
  end

  def new_changeset do
    changeset(%Account.Folder{}, %{})
  end
end
