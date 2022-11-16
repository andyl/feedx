defmodule FeedexCore.Util.Treemap do
  @moduledoc """
  Utilities for extracting data from a treemap. 
  """

  def folder_name(treemap, folder_id) do
    folder = treemap |> Enum.find(%{}, &(&1.id == folder_id))
    folder[:name]
  end

  def register_name(treemap, register_id) do
    register = find_register(treemap, register_id)
    register[:name]
  end

  def register_parent_id(treemap, register_id) do
    register = find_register(treemap, register_id)
    register[:folder_id]
  end

  def register_parent_name(treemap, register_id) do
    fldid = register_parent_id(treemap, register_id)
    folder_name(treemap, fldid)
  end

  defp find_register(treemap, register_id) do
      treemap
      |> Enum.map(& &1[:registers])
      |> List.flatten()
      |> Enum.find(%{}, &(&1.id == register_id))
  end
end
