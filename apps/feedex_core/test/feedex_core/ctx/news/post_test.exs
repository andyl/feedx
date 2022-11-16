defmodule FeedexCore.Ctx.News.PostTest do 
  use ExUnit.Case, async: true
  use FeedexCore.DataCase

  test "greet the world" do
    assert "hello" == "hello"
  end

  describe "changesets" do
    test "accepts valid input" do
      attr = %{feed_id: 1, body: "asdf", exid: "qwerq"}
      cs = Post.changeset(%Post{}, attr)
      assert cs.valid?
    end
  end

  describe "inserting records" do
    test "adds a record" do
      attr = %{body: "asdf", exid: "asdf"}
      cset = Post.changeset(%Post{}, attr)
      assert count(Post) == 0
      assert {:ok, _result} = Repo.insert(cset)
      assert count(Post) == 1
    end
  end

  describe "using Factory" do
    test "building an entity" do
      assert build(:post)
    end

    test "inserting an entity" do
      assert count(Post) == 0
      assert insert(:post)
      assert count(Post) == 1
    end

    test "inserting two entities" do
      assert count(Post) == 0
      assert insert(:post)
      assert insert(:post)
      assert count(Post) == 2
    end

    test "uses alternate attrs" do
      altname = "NEWNAME"
      assert count(Post) == 0
      assert trak = insert(:post, %{body: altname})
      assert count(Post) == 1
      assert trak.body == altname
    end
  end

  describe "deleting records" do
    test "all posts" do
      assert count(Post) == 0
      insert(:post)
      assert count(Post) == 1
      Repo.delete_all(Post)
      assert count(Post) == 0
    end
  end
end
