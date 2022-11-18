defmodule FeedxWeb.TreeComponent do
  @moduledoc """
  Renders the tree

  Call using:

      <%= live_component(@socket, FeedexUi.TreeComponent, id: "myid", uistate: @uistate) %>

  """

  # compare to PragStudio - `use FeedexUi.view, :live_component`
  use Phoenix.LiveComponent

  alias Phoenix.HTML
  import Phoenix.HTML
  import FeedxWeb.CountHelpers

  def render(assigns) do
    open_folder = get_open_fld(assigns.treemap, assigns.uistate)
    ~H"""
    <div class='mt-2 desktop-only'>
      <%= all_btn(@uistate, @myself) %> <%= unread(@counts.all, :raw) %><br/>
      <small>
      <%= for folder <- @treemap do %>
        <p></p>
        <%= fold_link(@uistate, @myself, folder) %>
        <%= unread(folder.id, @counts.fld, :raw) %>
        <%= if open_folder == folder.id do %>
        <%= for register <- folder.registers do %>
          <br/>
          > <%= reg_link(@uistate, @myself, register) %> <%= unread(register.id, @counts.reg, :raw) %>
        <% end %>
        <% end %>
      <% end %>
      </small>
      <%# HTML.raw state_table(@uistate) %>
    </div>
    """
  end

  # ----- view helpers -----

  def gen_counts(user_id) do
    %{
      all: FeedexCore.Ctx.News.unread_count_for(user_id),
      fld: FeedexCore.Ctx.News.unread_aggregate_count_for(user_id, type: "fld"),
      reg: FeedexCore.Ctx.News.unread_aggregate_count_for(user_id, type: "reg")
    }
  end

  def check_link(false), do: ""

  def check_link(_) do
    """
      <span style="margin-right: 10px">
      <a href='#'>
      <i class='bi-check' phx-click='mark-read'></i>
      </a>
      </span>
    """
  end

  def all_unread(_uistate, 0), do: ""
  def all_unread(_uistate, nil), do: ""

  def all_unread(uistate, count) do
    """
    <span class="badge bg-secondary up-3">
      <small>
        #{count}
      </small>
    </span>
    #{check_link(uistate.fld_id == nil && uistate.reg_id == nil)}
    """
    |> raw()
  end

  def fold_unread(_uistate, _id, 0), do: ""
  def fold_unread(_uistate, _id, nil), do: ""

  def fold_unread(uistate, id, count) do
    """
    <span class="badge bg-secondary up-5" >
      <small>
        #{count}
      </small>
    </span>
    #{check_link(uistate.fld_id == id)}
    """
    |> raw()
  end

  # -----

  defp all_btn(uistate, myself) do
    if uistate.mode == "view" && uistate.fld_id == nil && uistate.reg_id == nil do
      "<b>ALL</b>"
    else
      "<a phx-click='view_all' class='bluelink' phx-target='#{myself}' href='#'>ALL</a>"
    end
    |> HTML.raw()
  end

  defp fold_link(uistate, myself, folder) do
    if uistate.fld_id == folder.id && uistate.mode == "view" do
      "<b>#{folder.name}</b>"
    else
      """
      <a href='#' class='bluelink' phx-click='clk_folder' phx-target='#{myself}' phx-value-fldid='#{folder.id}'>
      #{folder.name}
      </a>
      """
    end
    |> HTML.raw()
  end

  defp reg_link(uistate, myself, register) do
    if uistate.reg_id == register.id && uistate.mode == "view" do
      "<b>#{register.name}</b>"
    else
      """
      <a href='#' phx-click='clk_feed' phx-target='#{myself}' phx-value-regid='#{register.id}'>#{register.name}</a>
      """
    end
    |> HTML.raw()
  end

  defp get_open_fld(treemap, uistate) do
    uistate.fld_id || get_fld(treemap, uistate.reg_id)
  end

  defp get_fld(treemap, regid) do
    case regid do
      nil -> nil
      id when is_number(id) -> FeedexCore.Util.Treemap.register_parent_id(treemap, id)
      _ -> nil
    end
  end

  def state_table(uistate) do
    """
      <hr/>
      <table class='table table-sm'>
        <tr><td>Mode</td> <td>#{uistate.mode}</td></tr>
        <tr><td>UsrId</td><td>#{uistate.usr_id}</td></tr>
        <tr><td>FldId</td><td>#{uistate.fld_id}</td></tr>
        <tr><td>RegId</td><td>#{uistate.reg_id}</td></tr>
        <tr><td>PstId</td><td>#{uistate.pst_id}</td></tr>
      </table>
    """
  end

  # ----- event handlers -----

  def handle_event("view_all", _payload, socket) do
    new_state = %{
      mode: "view",
      usr_id: socket.assigns.uistate.usr_id,
      reg_id: nil,
      fld_id: nil,
      pst_id: nil
    }

    send(self(), {"set_uistate", %{uistate: new_state}})

    {:noreply, assign(socket, %{uistate: new_state})}
  end

  def handle_event("clk_folder", %{"fldid" => fldid}, socket) do
    new_state = %{
      mode: "view",
      usr_id: socket.assigns.uistate.usr_id,
      fld_id: Integer.parse(fldid) |> elem(0),
      reg_id: nil,
      pst_id: nil
    }

    send(self(), {"set_uistate", %{uistate: new_state}})

    {:noreply, assign(socket, %{uistate: new_state})}
  end

  def handle_event("clk_feed", %{"regid" => regid}, socket) do
    new_state = %{
      mode: "view",
      usr_id: socket.assigns.uistate.usr_id,
      reg_id: Integer.parse(regid) |> elem(0),
      fld_id: nil,
      pst_id: nil
    }

    send(self(), {"set_uistate", %{uistate: new_state}})

    {:noreply, assign(socket, %{uistate: new_state})}
  end

  def handle_event("mark-read", _click, socket) do
    # FeedexWeb.News.Hdr.mark_all_read(socket.assigns.uistate)

    FeedexUi.Endpoint.broadcast_from(self(), "read_all", "mark-read", %{})

    treemap = FeedexCore.Api.SubTree.cleantree(socket.assigns.uistate.usr_id)
    counts = gen_counts(socket.assigns.uistate.usr_id)

    {:noreply, assign(socket, %{treemap: treemap, counts: counts})}
  end

end
