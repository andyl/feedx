defmodule FeedexCore.Ctx.Account.UserTest do 
  use ExUnit.Case, async: true
  use FeedexCore.DataCase

  describe "changesets" do
    test "accepts valid input" do
      tmap = %User{}
      attr = %{name: "asdf", email: "asdf@qwer.com"}
      cs = User.changeset(tmap, attr)
      assert cs.valid?
    end
  end

  describe "inserting records" do
    test "adds a record" do
      tmap = %User{}
      attr = %{name: "asdff", email: "zqwer@asdf.com", pwd_hash: "xxx"}
      cset = User.changeset(tmap, attr)
      assert count(User) == 0
      assert {:ok, _result} = Repo.insert(cset)
      assert count(User) == 1
    end
  end

  describe "signup" do
    test "adds a user with password" do
      attr = %{name: "asdf", email: "qwer.com", pwd: "bingbing"}
      cset = User.signup_changeset(%User{}, attr)
      assert count(User) == 0
      assert {:ok, _trak} = Repo.insert(cset)
      assert count(User) == 1
    end
  end

  describe "using Factory" do
    test "building an entity" do
      assert build(:user)
    end

    test "inserting an entity" do
      assert count(User) == 0
      assert insert(:user)
      assert count(User) == 1
    end

    test "inserting two entities" do
      assert count(User) == 0
      assert insert(:user)
      assert insert(:user)
      assert count(User) == 2
    end

    test "uses alternate attrs" do
      altname = "NEWNAME"
      assert count(User) == 0
      assert trak = insert(:user, %{name: altname})
      assert count(User) == 1
      assert trak.name == altname
    end
  end

  describe "deleting records" do
    test "all users" do
      assert count(User) == 0
      insert(:user)
      assert count(User) == 1
      Repo.delete_all(User)
      assert count(User) == 0
    end
  end
end
