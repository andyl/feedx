defmodule FeedxWeb.NavUtil do
  @moduledoc """
  Conveniences for navigation menus.
  """

  import Phoenix.HTML

  @doc """
  Generates tag for inlined form input errors.
  """
  def link(conn, link_path, label) do
    klas = if conn.request_path == link_path, do: active_klas(), else: normal_klas()
    ~e"""
    <a href="<%= link_path %>" class="<%= klas %>"><%= label %></a>
    """
  end

  def active_klas do
    "nav-link disabled"
  end

  def normal_klas do
    "nav-link active"
  end

end

