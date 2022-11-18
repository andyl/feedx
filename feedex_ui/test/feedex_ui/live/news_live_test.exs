defmodule FeedexUi.NewsLiveTest do
  use FeedexUi.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "access without login", %{conn: conn} do
    assert {:error, {:redirect, %{to: "/users/log_in"}}} = live(conn, "/news")
  end

  test "access with login", %{conn: base_conn} do
    auth_conn = register_and_log_in_user(%{conn: base_conn})
    {:ok, page_live, disconnected_html} = live(auth_conn.conn, "/news")
    assert disconnected_html =~ "ALL"
    assert render(page_live) =~ "ALL"
  end
end
