defmodule FeedexCore.FactoryTest do
  use FeedexCore.DataCase, async: true

  describe "data creation" do
    test "building an entity" do
      assert build(:post)
    end

    test "inserting a post" do
      assert count(Post) == 0
      assert count(Feed) == 0
      assert insert(:post)
      assert count(Post) == 1
      assert count(Feed) == 1
    end

    test "inserting a register" do
      assert count(Register) == 0
      assert count(Folder) == 0
      assert count(Feed) == 0
      assert count(User) == 0
      assert insert(:register)
      assert count(Register) == 1
      assert count(Folder) == 1
      assert count(Feed) == 1
      assert count(User) == 1
    end

    test "user with multi folders" do
      user = insert(:user)
      folder1 = insert(:folder, user: user)
      folder2 = insert(:folder, user: user)
      assert folder1.user_id == user.id
      assert folder2.user_id == user.id
      assert count(User) == 1
      assert count(Folder) == 2
    end

    test "build a tree" do
      user = insert(:user)
      fld1 = insert(:folder, user: user)
      fld2 = insert(:folder, user: user)
      reg1 = insert(:register, folder: fld1)
      reg2 = insert(:register, folder: fld1)
      assert fld1.user_id == user.id
      assert fld2.user_id == user.id
      assert reg1.folder_id == fld1.id
      assert reg2.folder_id == fld1.id
      assert count(User) == 1
      assert count(Folder) == 2
      assert count(Register) == 2
    end

    test "using gentree" do
      data = gentree()
      assert data
      assert data.fld1.user_id == data.user.id
      assert data.fld2.user_id == data.user.id
      assert data.reg1.folder_id == data.fld1.id
      assert data.reg2.folder_id == data.fld1.id
      assert count(User) == 1
      assert count(Folder) == 2
      assert count(Register) == 2
    end
  end

  defp gentree do
    user = insert(:user)
    fld1 = insert(:folder, user: user)
    fld2 = insert(:folder, user: user)
    reg1 = insert(:register, folder: fld1)
    reg2 = insert(:register, folder: fld1)
    %{user: user, fld1: fld1, fld2: fld2, reg1: reg1, reg2: reg2}
  end
end
