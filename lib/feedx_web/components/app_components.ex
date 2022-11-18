defmodule FeedxWeb.AppComponents do
  @moduledoc """
  Provides app UI components.
  """
  use Phoenix.Component

  @doc """
  Renders a styled link.
  """
  attr :href, :string, doc: "the link href"
  slot :inner_block, required: true

  def alink(assigns) do
    ~H"""
    <.link class="underline decoration-2 decoration-blue-400 hover:decoration-blue-800" href={@href}>
        <%= render_slot(@inner_block) %>
    </.link>
    """
  end

end
