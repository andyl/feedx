defmodule Feedx.Api.SubTreeTest do
  use ExUnit.Case, async: true
  use Feedx.DataCase

  alias Feedx.Api.SubTree


  describe "#rawtree" do
    test "returns a value" do
      data = gentree()
      assert SubTree.rawtree(data.user.id)
    end
  end

  describe "#cleantree" do
    test "returns a value" do
      data = gentree()
      assert SubTree.cleantree(data.user.id)
    end
  end

  describe "#list" do
    test "returns a value" do
      data = gentree()
      assert SubTree.list(data.user.id)
    end
  end

  describe "#import_folder / map" do
    test "basic input" do
      user = insert(:user)
      fld_name = "fld_name"
      reg_data = %{"feed_name" => "aaa", "feed_url" => "http://bbb.com"}
      assert count(User) == 1
      assert count(Folder) == 0
      assert count(Feed) == 0
      assert count(Register) == 0
      assert SubTree.import_folder(user.id, fld_name, reg_data)
      assert count(User) == 1
      assert count(Folder) == 1
      assert count(Feed) == 1
      assert count(Register) == 1
    end

    test "idempotency" do
      user = insert(:user)
      fld_name = "fld_name"
      reg_data = %{"feed_name" => "aaa", "feed_url" => "http://bbb.com"}
      assert SubTree.import_folder(user.id, fld_name, reg_data)
      assert SubTree.import_folder(user.id, fld_name, reg_data)
      assert count(User) == 1
      assert count(Folder) == 1
      assert count(Feed) == 1
      assert count(Register) == 1
    end
  end

  describe "#import_folder / list" do
    test "basic input" do
      user = insert(:user)
      fld_name = "fld_name"
      reg_data = [
        %{"feed_name" => "aaa", "feed_url" => "http://aaa.com"},
        %{"feed_name" => "bbb", "feed_url" => "http://bbb.com"}
      ]
      assert count(User) == 1
      assert count(Folder) == 0
      assert count(Feed) == 0
      assert count(Register) == 0
      assert SubTree.import_folder(user.id, fld_name, reg_data)
      assert count(User) == 1
      assert count(Folder) == 1
      assert count(Feed) == 2
      assert count(Register) == 2
    end

    test "idempotency" do
      user = insert(:user)
      fld_name = "fld_name"
      reg_data = [
        %{"feed_name" => "aaa", "feed_url" => "http://aaa.com"},
        %{"feed_name" => "bbb", "feed_url" => "http://bbb.com"}
      ]
      assert SubTree.import_folder(user.id, fld_name, reg_data)
      assert SubTree.import_folder(user.id, fld_name, reg_data)
      assert count(User) == 1
      assert count(Folder) == 1
      assert count(Feed) == 2
      assert count(Register) == 2
    end
  end

  describe "#import_register" do

    test "basic input" do
      fld = insert(:folder)
      reg_name = "asdf"
      feed_url = "qwer"
      assert count(User) == 1
      assert count(Folder) == 1
      assert count(Feed) == 0
      assert count(Register) == 0
      assert SubTree.import_register(fld.id, reg_name, feed_url)
      assert count(User) == 1
      assert count(Folder) == 1
      assert count(Feed) == 1
      assert count(Register) == 1
    end

    test "idempotency" do
      fld = insert(:folder)
      reg_name = "asdf"
      feed_url = "qwer"
      assert SubTree.import_register(fld.id, reg_name, feed_url)
      assert SubTree.import_register(fld.id, reg_name, feed_url)
      assert count(User) == 1
      assert count(Folder) == 1
      assert count(Feed) == 1
      assert count(Register) == 1
    end

  end


  describe "#import_tree" do
    test "basic input" do
      user = insert(:user)
      data = %{
        "BASE1" => [
        %{"feed_name" => "AAA", "feed_url" => "http://aaa.com"},
        %{"feed_name" => "BBB", "feed_url" => "http://bbb.com"}
      ],
        "BASE2" => [
        %{"feed_name" => "CCC", "feed_url" => "http://ccc.com"},
        %{"feed_name" => "DDD", "feed_url" => "http://ddd.com"}
        ]
      }
      assert SubTree.import_tree(user.id, data)
      assert count(User) == 1
      assert count(Folder) == 2
      assert count(Feed) == 4
      assert count(Register) == 4
    end

    test "idempotency" do
      user = insert(:user)
      data = %{
        "BASE1" => [
        %{"feed_name" => "AAA", "feed_url" => "http://aaa.com"},
        %{"feed_name" => "BBB", "feed_url" => "http://bbb.com"}
      ],
        "BASE2" => [
        %{"feed_name" => "CCC", "feed_url" => "http://ccc.com"},
        %{"feed_name" => "DDD", "feed_url" => "http://ddd.com"}
        ]
      }
      assert SubTree.import_tree(user.id, data)
      assert SubTree.import_tree(user.id, data)
      assert count(User) == 1
      assert count(Folder) == 2
      assert count(Feed) == 4
      assert count(Register) == 4
    end
  end

  describe "#import_json_tree" do
    test "basic input" do
      user = insert(:user)
      json = """
      {
        "BASE1" : [
        {"feed_name" : "AAA", "feed_url" : "http://aaa.com"},
        {"feed_name" : "BBB", "feed_url" : "http://bbb.com"}
        ],
        "BASE2" : [
        {"feed_name" : "CCC", "feed_url" : "http://ccc.com"},
        {"feed_name" : "DDD", "feed_url" : "http://ddd.com"}
        ]
      }
      """
      assert SubTree.import_tree_json(user.id, json)
      assert count(User) == 1
      assert count(Folder) == 2
      assert count(Feed) == 4
      assert count(Register) == 4
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
