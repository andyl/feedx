defmodule Feedx.Api.FolderTest do
  use ExUnit.Case, async: true
  use Feedx.DataCase

  alias Feedx.Api

  describe "#find_or_create_folder" do
    test "create a folder" do
      name = "ping"
      user = insert(:user)
      assert count(Folder) == 0
      folder = Api.Folder.find_or_create_folder(user.id, name)
      assert folder
      assert folder.name == name
      assert count(Folder) == 1
    end

    test "find a folder" do
      user = insert(:user)
      folder1 = insert(:folder, user: user)
      assert count(Folder) == 1
      folder2 = Api.Folder.find_or_create_folder(user.id, folder1.name)
      assert folder2
      assert folder2.id == folder1.id
      assert count(Folder) == 1
    end
  end
end
