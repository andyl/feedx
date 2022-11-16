defmodule Feedx.Factory do
  @moduledoc """
  ExMachina test constructors.
  """

  use ExMachina.Ecto, repo: Feedx.Repo
  alias Feedx.Ctx.Account.{User, Folder, Register}
  alias Feedx.Ctx.News.{Feed, Post}

  def feed_factory do
    %Feed{
      url: sequence(:url, &"http://test_dom.com/path_#{&1}")
    }
  end

  def post_factory do
    %Post{
      body: sequence(:body, &"body_#{&1}"),
      exid: sequence(:exid, &"exid_#{&1}"),
      feed: insert(:feed)
    }
  end

  def user_factory do
    pwd = "welcome"
    %User{
      name: sequence(:name, &"user_#{&1}"),
      email: sequence(:email, &"user_#{&1}@test_domain.com"),
      hashed_password: Pbkdf2.hash_pwd_salt(pwd)
    }
  end

  def folder_factory do
    %Folder{
      name: sequence(:name, &"folder_#{&1}"),
      user: fn -> insert(:user) end
    }
  end

  def register_factory do
    %Register{
      name: sequence(:name, &"register_#{&1}"),
      folder: fn -> insert(:folder) end,
      feed: insert(:feed)
    }
  end
end
