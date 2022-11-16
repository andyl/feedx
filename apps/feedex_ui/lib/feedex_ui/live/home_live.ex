defmodule FeedexUi.HomeLive do
  @moduledoc """
  Live View for Home Page
  """

  use FeedexUi, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
