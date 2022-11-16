defmodule FeedexCore.Ctx.News.FeedTest do 
  use ExUnit.Case, async: true
  use FeedexCore.DataCase

  test "greet the world" do
    assert "hello" == "hello"
  end

  describe "changesets" do
    test "accepts valid input" do
      tmap = %Feed{}
      attr = %{url: "asdf"}
      cs = Feed.changeset(tmap, attr)
      assert cs.valid?
    end
  end

  describe "inserting records" do
    test "adds a record" do
      tmap = %Feed{}
      attr = %{url: "asdf"}
      cset = Feed.changeset(tmap, attr)
      assert count(Feed) == 0
      assert {:ok, _result} = Repo.insert(cset)
      assert count(Feed) == 1
    end
  end

  describe "using Factory" do
    test "building an entity" do
      assert build(:feed)
    end

    test "inserting an entity" do
      assert count(Feed) == 0
      assert insert(:feed)
      assert count(Feed) == 1
    end

    test "inserting two entities" do
      assert count(Feed) == 0
      assert insert(:feed)
      assert insert(:feed)
      assert count(Feed) == 2
    end

    test "uses alternate attrs" do
      altname = "NEWNAME"
      assert count(Feed) == 0
      assert trak = insert(:feed, %{url: altname})
      assert count(Feed) == 1
      assert trak.url == altname
    end
  end

  describe "deleting records" do
    test "all feeds" do
      assert count(Feed) == 0
      insert(:feed)
      assert count(Feed) == 1
      Repo.delete_all(Feed)
      assert count(Feed) == 0
    end
  end
end
