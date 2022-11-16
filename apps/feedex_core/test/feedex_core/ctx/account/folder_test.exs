defmodule FeedexCore.Ctx.Account.FolderTest do
  use ExUnit.Case, async: true
  use FeedexCore.DataCase

  test "greet the world" do
    assert "hello" == "hello"
  end

  describe "changesets" do
    test "accepts valid input" do
      tmap = %Folder{}
      attr = %{name: "asdf", user_id: 1}
      cs = Folder.changeset(tmap, attr)
      assert cs.valid?
    end
  end

  describe "inserting records" do
    test "adds a record" do
      tmap = %Folder{}
      attr = %{name: "asdf"}
      cset = Folder.changeset(tmap, attr)
      assert count(Folder) == 0
      assert {:ok, _result} = Repo.insert(cset)
      assert count(Folder) == 1
    end
  end

  describe "using Factory" do
    test "building an entity" do
      assert build(:folder)
    end

    test "inserting an entity" do
      assert count(Folder) == 0
      assert insert(:folder)
      assert count(Folder) == 1
    end

    test "inserting two entities" do
      fqry = from(t in "folders", select: count(t.id))
      uqry = from(t in "users", select: count(t.id))
      assert Repo.one(fqry) == 0
      assert insert(:folder)
      assert insert(:folder)
      assert Repo.one(fqry) == 2
      assert Repo.one(uqry) == 2
    end

    test "uses alternate attrs" do
      altname = "NEWNAME"
      assert count(Folder) == 0
      assert trak = insert(:folder, %{name: altname})
      assert count(Folder) == 1
      assert trak.name == altname
    end
  end

  describe "deleting records" do
    test "all folders" do
      assert count(Folder) == 0
      insert(:folder)
      assert count(Folder) == 1
      Repo.delete_all(Folder)
      assert count(Folder) == 0
    end
  end

  describe "duplicate folder names" do
    test "raise error using factory" do
      name = "bing"
      user = insert(:user)
      assert insert(:folder, user: user, name: name)
      assert_raise Ecto.ConstraintError, fn -> insert(:folder, user: user, name: name) end
    end

    test "invalid using changeset" do
      name = "bing"
      user = insert(:user)
      assert insert(:folder, user: user, name: name)
      params = params_for(:folder, user: user, name: name)
      attrs = %Folder{} |> Folder.changeset(params)
      {:error, changeset} = Repo.insert(attrs)
      refute changeset.valid?
    end
  end

  describe "user association" do
    test "finds the user from the folder" do
      fusr =
        from(f in "folders",
          join: u in "users",
          on: [id: f.user_id],
          select: {f.name, u.name}
        )
      insert(:folder)
      result = Repo.all(fusr)
      assert Enum.count(result) == 1
    end 

    test "finds the folder from the user" do
      ufold =
        from(u in "users",
          join: f in "folders",
          on: u.id == f.user_id,
          select: {f.name, u.name}
        ) 
      insert(:folder)
      result = Repo.all(ufold)
      assert Enum.count(result) == 1
    end
  end
end
