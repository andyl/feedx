defmodule Feedx.Ctx.Account.RegisterTest do
  use ExUnit.Case, async: true
  use Feedx.DataCase

  test "greet the world" do
    assert "hello" == "hello"
  end

  describe "changesets" do
    test "accepts valid input" do
      tmap = %Register{}
      attr = %{name: "asdf"}
      cs = Register.changeset(tmap, attr)
      assert cs.valid?
    end
  end

  describe "inserting records" do
    test "adds a record" do
      tmap = %Register{}
      attr = %{name: "asdf"}
      cset = Register.changeset(tmap, attr)
      assert count(Register) == 0
      assert {:ok, _result} = Repo.insert(cset)
      assert count(Register) == 1
    end
  end

  describe "using Factory" do
    test "building an entity" do
      assert build(:register)
    end

    test "inserting an entity" do
      assert count(Register) == 0
      assert insert(:register)
      assert count(Register) == 1
    end

    test "inserting two entities" do
      fqry = from(t in "registers", select: count(t.id))
      uqry = from(t in "users", select: count(t.id))
      assert Repo.one(fqry) == 0
      assert insert(:register)
      assert insert(:register)
      assert Repo.one(fqry) == 2
      assert Repo.one(uqry) == 2
    end

    test "uses alternate attrs" do
      altname = "NEWNAME"
      assert count(Register) == 0
      assert trak = insert(:register, %{name: altname})
      assert count(Register) == 1
      assert trak.name == altname
    end
  end

  describe "deleting records" do
    test "all registers" do
      assert count(Register) == 0
      insert(:register)
      assert count(Register) == 1
      Repo.delete_all(Register)
      assert count(Register) == 0
    end
  end

  describe "folder association" do
    test "finds the folder from the register" do
      fusr =
        from(f in "registers",
          join: u in "folders",
          on: [id: f.folder_id],
          select: {f.name, u.name}
        )
      insert(:register)
      result = Repo.all(fusr)
      assert Enum.count(result) == 1
    end

    test "finds the register from the folder" do
      ufold =
        from(u in "folders",
          join: f in "registers",
          on: u.id == f.folder_id,
          select: {f.name, u.name}
        )
      insert(:register)
      result = Repo.all(ufold)
      assert Enum.count(result) == 1
    end
  end
end
