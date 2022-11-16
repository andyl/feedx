defmodule FeedexUi.BtnComponent do
  @moduledoc """
  Renders the btn component.

  Call using:

      <%= live_component(@socket, FeedexUi.BtnComponent, uistate: @uistate) %>

  """

  use Phoenix.LiveComponent
  import Phoenix.HTML
  import FeedexUi.BootstrapIconHelpers

  def render(assigns) do
    ~L"""
    <div class="py-1 desktop-only">
      <hr/> 
      <%= folder_btn(@uistate, @myself) %>
      <%= feed_btn(@uistate, @myself) %>
    </div>
    """
  end
  
  # ----- view helpers -----

  def folder_btn(uistate, myself) do
    label = "#{plus_circle_svg("up-9 h-5")} Folder<br/>"
    if uistate.mode != "add_folder" do
      "<a phx-click='add_folder' phx-target='#{myself}' href='#'>#{label}</a>"
    else
      ""
    end |> raw()
  end

  def feed_btn(uistate, myself) do
    label = "#{plus_circle_svg("up-9 h-5")} Feed<br/>"
    if uistate.mode != "add_feed" do
      "<a phx-click='add_feed' phx-target='#{myself}' href='#'>#{label}</a>"
    else
      ""
    end |> raw()
  end

  # ----- event handlers -----
  
  def handle_event("view_all", _payload, socket) do
    opts = %{
      mode: "view",
      usr_id: socket.assigns.uistate.usr_id,
      reg_id: nil,
      fld_id: nil,
      pst_id: nil
    }

    new_state = Map.merge(socket.assigns.uistate, opts)

    send(self(), {"set_uistate", %{uistate: new_state}})

    {:noreply, assign(socket, %{uistate: opts})}
  end

  def handle_event("add_feed", _payload, socket) do
    click_handle("add_feed", socket)
  end

  def handle_event("add_folder", _payload, socket) do
    click_handle("add_folder", socket)
  end

  # ----- event helpers -----

  defp click_handle(mode, socket) do
    new_state = %{
      mode: mode,
      usr_id: socket.assigns.uistate.usr_id,
      reg_id: nil,
      fld_id: nil,
      pst_id: nil
    }

    send(self(), {"set_uistate", %{uistate: new_state}})

    {:noreply, assign(socket, %{uistate: new_state})}
  end

end
