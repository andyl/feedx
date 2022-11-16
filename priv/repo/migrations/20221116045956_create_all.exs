defmodule Feedx.Repo.Migrations.CreateAll do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :name, :string
      add :email, :citext, null: false
      add :admin, :boolean
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      add :last_seen_at, :naive_datetime
      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])

    # News.Feed
    create table(:feeds) do
      add(:url,        :string)
      add(:sync_count, :integer, default: 0)
      timestamps(type: :utc_datetime)
    end

    # News.Post
    create table(:posts) do
      add(:feed_id, references(:feeds, on_delete: :delete_all))
      add(:exid,    :string)
      add(:title,   :string)
      add(:body,    :text)
      add(:author,  :string)
      add(:link,    :string)
      timestamps(type: :utc_datetime)
    end
    create index(:posts, [:feed_id])
    create index(:posts, [:exid])
    create index(:posts, [:title])

    # Account.Folder
    create table(:folders) do
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:name, :string)
      add(:stopwords, :string)
      timestamps(type: :utc_datetime)
    end
    create index(:folders, [:user_id])
    create unique_index(:folders, [:user_id, :name], name: :folder_user_name_index)

    # Account.Register
    create table(:registers) do
      add(:folder_id, references(:folders, on_delete: :delete_all))
      add(:feed_id,   references(:feeds, on_delete: :delete_all))
      add(:name,       :string)
      timestamps(type: :utc_datetime)
    end
    create index(:registers, [:folder_id])
    create index(:registers, [:feed_id])
    create unique_index(:registers, [:folder_id, :name])

    # Account.ReadLogs
    create table(:read_logs) do
      add(:user_id,     references(:users, on_delete: :delete_all))
      add(:folder_id,   references(:folders, on_delete: :delete_all))
      add(:register_id, references(:registers, on_delete: :delete_all))
      add(:post_id,     references(:posts, on_delete: :delete_all))
    end
    create index(:read_logs, [:user_id])
    create index(:read_logs, [:folder_id])
    create index(:read_logs, [:register_id])
    create index(:read_logs, [:post_id])
    create unique_index(
      :read_logs,
      [:user_id, :folder_id, :register_id, :post_id],
      name: :unique_read_log
    )

  end
end
