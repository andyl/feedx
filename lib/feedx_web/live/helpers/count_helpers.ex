defmodule FeedxWeb.CountHelpers do

  @moduledoc """
  HTML helpers for live views.
  """

  import Phoenix.HTML

  def unread(0), do: ""

  def unread(count) do
    """
    <span class="badge bg-secondary up-4">
      <small>
        #{count}
      </small>
    </span>
    """
  end

  def unread(count, :raw) do
    unread(count) |> raw()
  end

  def unread(id, unread_count) do
    unread(unread_count[id] || 0)
  end

  def unread(id, unread_count, :raw) do
    unread(id, unread_count) |> raw()
  end

end
