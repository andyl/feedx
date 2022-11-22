defmodule FeedxWeb.BodyEditFeedComponent do
  @moduledoc """
  Renders the body edit feed component.

  Call using:

      <%= live_component(FeedexUi.BodyEditFeedComponent, uistate: @uistate) %>

  """

  alias Feedx.Ctx.News.Post
  alias Feedx.Ctx.News.Feed
  alias Feedx.Ctx.Account.Register
  alias Feedx.Ctx.Account.Folder
  alias Feedx.Repo

  import Ecto.Query
  import Phoenix.HTML

  use Phoenix.LiveComponent
  # use Phoenix.LiveEditable

  require Logger

  # ----- lifecycle callbacks -----

  @impl true
  def update(session, socket) do
    reg_id = session.uistate.reg_id
    usr_id = session.uistate.usr_id
    register = Repo.get(Register, reg_id)

    opts =
      if register do
        feed_count =
          from(reg in Register, select: count(reg.id), where: reg.feed_id == ^register.feed_id)
          |> Repo.one()

        post_count =
          from(pst in Post, select: count(pst.id), where: pst.feed_id == ^register.feed_id)
          |> Repo.one()

        folders = from(fld in Folder,
          select: {fld.id, fld.name},
          where: fld.user_id == ^usr_id,
          order_by: fld.name
        ) |> Repo.all()

        %{
          register: register,
          feed_count: feed_count,
          feed: Repo.get(Feed, register.feed_id),
          folder: Repo.get(Folder, register.folder_id),
          folders: folders,
          post_count: post_count,
          uistate: session.uistate
        }
      else
        %{
          register: nil,
          feed_count: 0,
          feed: nil,
          folder: nil,
          folders: nil,
          post_count: 0,
          changeset: %Register{},
          uistate: session.uistate
        }
      end

    {:ok, assign(socket, opts)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
    <h1>EDIT FEED</h1>
    <%= if @register do %>
      <table class="table">
      <tr><td>Reg Name:</td><td>TBD<%# live_edit(assigns, @register.name, type: "text", id: "name", target: @myself, on_submit: "rename") %></td></tr>
      <tr><td>Reg Folder:</td><td>TBD<%# live_edit(assigns, @folder.name, type: "select", options: @folders, target: @myself, id: "folder", on_submit: "refolder") %></td></tr>
      <tr><td>FeedUrl:</td><td><%= feed_link(@feed) %></td></tr>
      <tr><td>Usr/Registry ID:</td><td><%= @register.id %></td></tr>
      <tr><td>Attached Registries:</td><td><%= @feed_count %></td></tr>
      <tr><td>Post Count:</td><td><%= @post_count %></td></tr>
      <tr><td>Sync Count:</td><td><%= @feed.sync_count %></td></tr>
      </table>
    <p style='margin-bottom: 60px;'></p>
    <button type="button" phx-click="delete" phx-target={@myself} class="btn btn-danger">Delete Feed</button>
    <% end %>
    </div>
    """
  end

  # ----- view helpers -----

  def feed_link(feed) do
    """
    <a href="#{feed.url}" target="_blank">
    #{feed.url}
    </a>
    """ |> raw()
  end

  # ----- data helpers -----

  # ----- event handlers -----

  @impl true
  def handle_event("delete", _payload, socket) do
    register = Repo.get(Register, socket.assigns.uistate.reg_id)

    fld_id = register.folder_id

    feed_count =
      from(r in Register, select: count(r.id), where: r.feed_id == ^register.feed_id)
      |> Repo.one()

    try do
    if feed_count == 1 do
      Repo.get(Feed, register.feed_id) |> Repo.delete()
    end
    rescue
      _ -> Logger.info("Warning: delete feed error")
    end

    try do
    Repo.delete(register)
    rescue
      _ -> Logger.info("Warning: delete register error")
    end

    send(self(), {"delete_feed", %{fld_id: fld_id}})

    {:noreply, socket}
  end

  @impl true
  def handle_event("rename", %{"editable_text" => newname}, socket) do
    Register
    |> Repo.get(socket.assigns.uistate.reg_id)
    |> Ecto.Changeset.change(name: newname)
    |> Repo.update()
    send(self(), "rename_feed")
    {:noreply, socket}
  end

  @impl true
  def handle_event("refolder", %{"editable_select" => fldid}, socket) do
    Register
    |> Repo.get(socket.assigns.uistate.reg_id)
    |> Ecto.Changeset.change(folder_id: String.to_integer(fldid))
    |> Repo.update()

    send(self(), "refolder_feed")
    {:noreply, socket}
  end

end
