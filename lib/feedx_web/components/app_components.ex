defmodule FeedxWeb.AppComponents do
  @moduledoc """
  Provides app UI components.
  """
  use Phoenix.Component

  @doc """
  Renders a styled link.
  """
  attr :href, :string, doc: "the link href"
  attr :class, :string, doc: "custom classes", default: ""
  attr :rest, :global, doc: "custom HTML attributes", default: %{}
  slot :inner_block, required: true

  def alink(assigns) do
    ~H"""
    <.link
      class={"underline decoration-2 decoration-blue-400 hover:decoration-blue-800 #{@class}"}
      href={@href}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end
end
