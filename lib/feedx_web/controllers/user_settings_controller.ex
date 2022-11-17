defmodule FeedxWeb.UserSettingsController do
  use FeedxWeb, :controller

  alias Feedx.Accounts
  alias FeedxWeb.UserAuth
  alias FeedxCore.Api.SubTree

  def subs_json(conn, _params) do
    subs = conn |> current_user_id() |> SubTree.list()
    conn
    |> json(subs)
  end

  defp current_user_id(conn) do
    conn.assigns.current_user.id
  end

end
