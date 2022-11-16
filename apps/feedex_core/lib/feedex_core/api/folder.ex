defmodule FeedexCore.Api.Folder do
  @moduledoc """
  Utilities for working with Folders.
  """

  alias FeedexCore.Ctx.Account.Folder
  alias FeedexCore.Repo

  def find_or_create_folder(user_id, name) do
    find_folder(user_id, name) || create_folder(user_id, name)
  end

  defp find_folder(user_id, name) do
    Repo.get_by(Folder, user_id: user_id, name: name)
  end

  defp create_folder(user_id, name) do
    params = %{user_id: user_id, name: name}
    {:ok, folder} = %Folder{} |> Folder.changeset(params) |> Repo.insert()
    folder
  end

  def folder_validation_changeset(name) do
    params = %{name: name}
    %Folder{} |> Folder.changeset(params)
  end
end
