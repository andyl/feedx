defmodule FeedxWeb.HdrComponent do
  @moduledoc """
  Renders the hdr component.

  Call using:

      <%= live_component(@socket, FeedexUi.HdrComponent, uistate: @uistate) %>

  """

  use Phoenix.LiveComponent

  alias Phoenix.HTML
  alias Feedx.Ctx.Account
  alias Feedx.Util.Treemap
  import FeedxWeb.CountHelpers
  import FeedxWeb.BootstrapIconHelpers

  # ----- lifecycle callbacks -----

  @impl true
  def render(assigns) do
    ~H"""
    <div class="desktop-only" style="background-color: lightgray; padding: 5px; padding-right: 20px;">
      <%= if @uistate.mode == "view" do %>
        <div class='d-flex'>
          <div class='flex-grow-1'>
            <%= title(@uistate, @counts, @treemap, @myself) %>
          </div>
          <div class='text-right'>
            <%= HTML.raw btns(@uistate, @myself) %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  # ----- view helpers -----

  defp title(state, counts, treemap, myself) do
    case {state.fld_id, state.reg_id} do
      {nil   , nil} -> all_title(counts, myself)
      {fld_id, nil} -> fld_title(fld_id, counts, treemap, myself)
      {nil, reg_id} -> reg_title(reg_id, counts, treemap, myself)
    end |> HTML.raw()
  end

  defp all_title(counts, myself) do
    count = counts.all
    if count > 0 do
      "ALL " <> checklink(count, myself)
    else
      "ALL"
    end
  end

  defp fld_title(fld_id, counts, treemap, myself) do
    fname = Treemap.folder_name(treemap, fld_id)
    count = counts.fld[fld_id] || 0
    label = if count > 0, do: checklink(count, myself), else: ""
    "#{fname} #{label}"
  end

  defp reg_title(reg_id, counts, treemap, myself) do
    count = counts.reg[reg_id] || 0
    reg_name = Treemap.register_name(treemap, reg_id)
    fld_id   = Treemap.register_parent_id(treemap, reg_id)
    fld_name = Treemap.register_parent_name(treemap, reg_id)
    fld_base = "href='#' phx-click='folder-clk' phx-value-fldid='#{fld_id}'"
    fld_link = "<a #{fld_base} phx-target='#{myself}'>#{fld_name}</a> "
    label = if count > 0, do: checklink(count, myself), else: ""
    "#{fld_link} > #{reg_name} #{label}"
  end

  defp checklink(count, myself) do
    """
    #{unread(count)}
    <a href='#' phx-target="#{myself}" phx-click="mark-read">
      #{check_circle_svg("h-8 inline")}
    </a>
    """
  end

  defp btns(state, myself) do
    show_pencil = state.reg_id != nil || state.fld_id != nil
    pencil =
      if show_pencil do
        """
        <a href='#' phx-target='#{myself}' phx-click='click-edit'>
          #{pencil_alt_svg("h-4 inline")}
        </a>
        """
      else
        ""
      end

    """
    <a href='#' phx-target='#{myself}' phx-click='feed-sync'>
      #{refresh_svg("h-4 inline")}
    </a>
    #{pencil}
    """
  end

  # ----- data helpers -----

  def mark_all_read(state) do
    case {state.fld_id, state.reg_id} do
      {nil   , nil} -> Account.mark_all_for(state.usr_id)
      {fld_id, nil} -> Account.mark_all_for(state.usr_id, fld_id: fld_id)
      {nil, reg_id} -> Account.mark_all_for(state.usr_id, reg_id: reg_id)
    end
  end

  def sync_all(state) do
    case {state.fld_id, state.reg_id} do
      {nil   , nil} -> FeedxJob.sync_for(state.usr_id)
      {fld_id, nil} -> FeedxJob.sync_for(state.usr_id, fld_id: fld_id)
      {nil, reg_id} -> FeedxJob.sync_for(state.usr_id, reg_id: reg_id)
    end
  end

  # ----- event handlers -----

  @impl true
  def handle_event("folder-clk", %{"fldid" => fldid}, socket) do
    new_state = %{
      mode: "view",
      usr_id: socket.assigns.uistate.usr_id,
      fld_id: Integer.parse(fldid) |> elem(0),
      reg_id: nil,
      pst_id: nil
    }

    send(self(), {"set_uistate", %{uistate: new_state}})

    {:noreply, assign(socket, uistate: new_state)}
  end

  @impl true
  def handle_event("click-edit", _click, socket) do
    uistate = socket.assigns.uistate
    new_mode = case {uistate.fld_id, uistate.reg_id} do
      {_id, nil} -> "edit_folder"
      {nil, _id} -> "edit_feed"
    end
    new_state = Map.merge(uistate, %{mode: new_mode})
    send(self(), {"set_uistate", %{uistate: new_state}})
    {:noreply, assign(socket, %{uistate: new_state})}
  end

  @impl true
  def handle_event("feed-sync", _click, socket) do
    sync_all(socket.assigns.uistate)
    {:noreply, socket}
  end

  @impl true
  def handle_event("mark-read", _click, socket) do
    mark_all_read(socket.assigns.uistate)

    send(self(), "mark_all_read")

    {:noreply, socket}
  end

end
