defmodule FeedexUi.HomeLiveTest do
  use FeedexUi.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")

    assert disconnected_html =~ "Welcome to Feedex!"
    assert render(page_live) =~ "Welcome to Feedex!"
  end
end
