defmodule FeedxWeb.ClockLive do
  @moduledoc """
  Renders a live clock that updates at a periodic interval.

  The clock update frequency (`interval`) and the output format (`strftime`)
  are configurable session options.

  To call from the parent template:

      <%= live_render(@socket, FeedexUi.ClockLive, id: 1, session: %{"interval" => 10_000}) %>
      <%= live_render(@socket, FeedexUi.ClockLive, id: 2, session: %{"strftime" => "%H:%M"}) %>

  """

  use Phoenix.LiveView

  @impl true
  def mount(_params, session, socket) do
    start_timer(session["interval"] || 10_000)
    strftime = session["strftime"] || "%b %d %a %H:%M"
    klas = session["klas"] || "fs-6 text-left"
    state = [strftime: strftime, date: local_date(strftime), klas: klas]
    {:ok, assign(socket, state)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="<%= @klas %> desktop-only mt-1">
      <small>
        <%= @date %>
      </small>
    </div>
    """
  end

  @impl true
  def handle_info(:clock_tick, socket) do
    newdate = socket.assigns.strftime |> local_date()
    {:noreply, update(socket, :date, fn _ -> newdate end)}
  end

  defp start_timer(interval) do
    :timer.send_interval(interval, self(), :clock_tick)
  end

  defp local_date(format) do
    NaiveDateTime.local_now()
    |> Calendar.strftime(format)
  end
end
