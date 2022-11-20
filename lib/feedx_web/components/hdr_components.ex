defmodule FeedxWeb.HdrComponents do
  @moduledoc """
  Provides app UI components.
  """
  use Phoenix.Component

  @doc """
  Nav bar derived from DaisyUI.
  """
  attr :current_user, :any, doc: "Current user", default: nil

  def nav(assigns) do
    ~H"""
    <div class="navbar bg-neutral text-neutral-content">
      <div class="flex-1">
        <img src="/images/rss.png"/>
        <a class="btn btn-ghost normal-case text-xl" href="/">Feedx</a>
      </div>
      <div class="flex-none">
        <ul class="menu menu-horizontal p-0">
        <%= if @current_user do %>
          <.navbtn><%= @current_user.email %></.navbtn>
          <.navbtn href="/news">News</.navbtn>
          <.navbtn href="/users/settings">Settings</.navbtn>
          <.navbtn href="/users/log_out" method="delete">Log out</.navbtn>
        <% else %>
          <.navbtn href="/users/register">Register</.navbtn>
          <.navbtn href="/users/log_in">Log in</.navbtn>
        <% end %>
        </ul>
      </div>
    </div>
    """
  end

  @doc """
  Nav bar button.
  """
  attr :href, :string, doc: "Link href", default: nil
  attr :method, :string, doc: "Href method", default: nil

  slot :inner_block, required: true

  def navbtn(assigns) do
    ~H"""
    <li>
      <.link class="hover:bg-gray-800" href={@href} method={@method}>
        <%= render_slot(@inner_block) %>
      </.link>
    </li>
    """
  end
end
