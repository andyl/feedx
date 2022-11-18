defmodule FeedxWeb.TextComponent do
  @moduledoc """
  Renders a simple output string.

  Call using:

      <%= live_component(@socket, FeedexUi.TextComponent, text: "MyText") %>

  """

  use Phoenix.LiveComponent

  def render(assigns) do
    lcl_text = assigns[:text] || "Default Text"
    ~H"""
    <%= lcl_text %>
    """
  end
end
