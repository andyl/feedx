defmodule FeedexCore.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  alias FeedexCore.Repo
  alias FeedexCore.Ctx.Account.{User, Folder, Register, ReadLog}
  alias FeedexCore.Ctx.News.{Feed, Post}

  require Ecto.Query

  using do
    quote do
      alias FeedexCore.Repo
      alias FeedexCore.Ctx.Account
      alias FeedexCore.Ctx.Account.{User, Folder, Register, ReadLog}
      alias FeedexCore.Ctx.News
      alias FeedexCore.Ctx.News.{Feed, Post}

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import FeedexCore.DataCase
      import FeedexCore.Factory
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(FeedexCore.Repo)

    Repo.delete_all(ReadLog)
    Repo.delete_all(Register)
    Repo.delete_all(Folder)
    Repo.delete_all(Post)
    Repo.delete_all(Feed)
    Repo.delete_all(User)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(FeedexCore.Repo, {:shared, self()})
    end

    :ok
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  def count(type) do
    Ecto.Query.from(element in type, select: count(element.id))
    |> Repo.one()
  end

  def load_test_data(_ctx \\ []) do
    Repo.insert(%User{
      name: "test",
      email: "test",
      pwd_hash: User.pwd_hash("test"),
      folders: [
        %Folder{
          name: "Elixir",
          registers: [
            %Register{
              name: "Plataformatec",
              feed: %Feed{url: "http://blog.plataformatec.com.br/tag/elixir/feed"}
            },
            %Register{
              name: "Amberbit",
              feed: %Feed{url: "https://www.amberbit.com/blog.rss"}
            }
          ]
        },
        %Folder{
          name: "TechNews",
          registers: [
            %Register{
              name: "TechMeme",
              feed: %Feed{url: "http://www.techmeme.com/feed.xml"}
            },
            %Register{
              name: "MitReview",
              feed: %Feed{url: "https://www.technologyreview.com/topnews.rss"}
            }
          ]
        }
      ]
    })

    :ok
  end
end
