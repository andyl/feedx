defmodule Feedx.Api.SubTree do
  @moduledoc """
  Utilities for working with Subscription Trees.

  Subscription trees are concerned with Users, Folders, Registers, and Feeds.
  """

  alias Feedx.Ctx.Account.Folder
  alias Feedx.Ctx.Account.Register
  alias Feedx.Ctx.News.Feed
  alias Feedx.Repo
  alias Feedx.Api
  # alias Modex.AltMap
  import Ecto.Query

  @doc """
  List SubTrees.

  Used on the user_settings/subscriptions page.
  """
  def list(user_id) do
    user_id
    |> query()
    |> Repo.all()
    |> convert()
  end

  # @doc """
  # List SubTrees - stripped down data.
  #
  # Used by live/components/tree_component.
  # """
  # def cleantree(user_id) do
  #   rawtree(user_id)
  #   |> AltMap.retake([:id, :name, :user_id, :registers])
  # end

  @doc """
  List SubTrees - full data.
  """
  def rawtree(user_id) do
    uid = user_id
    rq =
      from(r in Register,
        order_by: r.name,
        select: %{folder_id: r.folder_id, id: r.id, name: r.name}
      )

    from(
      f in Folder,
      where: f.user_id == ^uid,
      order_by: f.name,
      preload: [registers: ^rq]
    )
    |> Repo.all()
  end

  def import_tree_json(user_id, json) do
    {:ok, data} = Jason.decode(json)
    import_tree(user_id, data)
  end

  def import_tree(user_id, data) do
    data |> Enum.map(fn({fname, flist}) -> import_folder(user_id, fname, flist) end)
  end

  def import_folder(user_id, folder_name, feed_list) when is_list(feed_list) do
    folder = Api.Folder.find_or_create_folder(user_id, folder_name)

    reg_list =
      feed_list
      |> Enum.map(&Api.RegFeed.find_or_create_regfeed(folder.id, &1["feed_name"], &1["feed_url"]))

    %{folder: folder, reg_list: reg_list}
  end

  def import_folder(user_id, folder_name, feed_map) when is_map(feed_map) do
    fld = Api.Folder.find_or_create_folder(user_id, folder_name)
    reg = Api.RegFeed.find_or_create_regfeed(fld.id, feed_map["feed_name"], feed_map["feed_url"])
    %{folder: fld, reg_list: [reg]}
  end

  def import_register(fld_id, reg_name, feed_url) do
    Api.RegFeed.find_or_create_regfeed(fld_id, reg_name, feed_url)
  end

  defp query(user_id) do
    from(fld in Folder,
      left_join: reg in Register,
      on: fld.id == reg.folder_id,
      left_join: fee in Feed,
      on: fee.id == reg.feed_id,
      where: fld.user_id == ^user_id,
      order_by: [fld.name, reg.name],
      select: {fld.name, reg.name, fee.url}
    )
  end

  defp convert(list) do
    list
    |> Enum.reduce(%{}, fn el, acc -> update_lst(el, acc) end)
  end

  defp update_lst({folder_name, fname, furl}, map) do
    list1 = if fname, do: [%{feed_name: fname, feed_url: furl}], else: []
    list2 = (map[folder_name] || []) ++ list1
    Map.merge(map, %{folder_name => list2})
  end
end
