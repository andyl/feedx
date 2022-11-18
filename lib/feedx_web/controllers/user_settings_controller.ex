defmodule FeedxWeb.UserSettingsController do
  use FeedxWeb, :controller

  alias Feedx.Api.SubTree


  def subs_json(conn, _params) do
    subs = conn |> current_user_id() |> SubTree.list()
    conn
    |> json(subs)
  end

  def subs(conn, _params) do
    subs = conn |> current_user_id() |> SubTree.list()
    conn
    |> assign(:subs, subs)
    |> render(:subs)
  end

  defp current_user_id(conn) do
    conn.assigns.current_user.id
  end

end
