defmodule FeedxWeb.BodyAddFeedComponent do
  @moduledoc """
  Renders the body add feed component.

  Call using:

      <%= live_component(@socket, FeedxWeb.BodyAddFeedComponent, uistate: @uistate) %>

  """

  alias Feedx.Ctx.Account
  alias Feedx.Ctx.Account.Folder
  # alias Feedx.Ctx.Account.Register
  # alias Feedx.Ctx.News.Feed
  alias Feedx.Repo

  # import Phoenix.HTML.Form
  import FeedxWeb.CoreComponents
  # import FeedxWeb.ErrorHelpers
  import Ecto.Query

  use Phoenix.LiveComponent

  # ----- lifecycle callbacks -----

  @impl true
  def update(session, socket) do
    opts = %{
      changeset: Account.RegFeed.new_changeset(),
      uistate: session.uistate
    }
    {:ok, assign(socket, opts)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="font-bold">Create a new Feed</div>
    <div>
      <.simple_form :let={f} for={@changeset} phx-target={@myself} phx-change="validate" phx-submit="save">
        <.input field={{f, :name}} label="Feed Name" />
        <.input field={{f, :url }} label="Feed Url" />
        <.input type="select" field={{f, :folder_id }} options={folders_for(@uistate)} label="Folder" />
        <:actions>
          <%= if @changeset.valid? do %>
            <.button>Save</.button>
          <% else %>
            <.button class="line-through">Save</.button>
          <% end %>
        </:actions>
      </.simple_form>
    </div>
    </div>
    """
  end

  # ----- view helpers -----

  def folders_for(uistate) do
    user_id = uistate.usr_id
    from(
      f in Folder,
      where: f.user_id == ^user_id
    )
    |> Repo.all()
    |> Enum.map(fn(el) -> {el.name, el.id} end)
  end

  # ----- event handlers -----

  @impl true
  def handle_event("validate", payload, socket) do
    params = %{
      name: payload["reg_feed"]["name"],
      url:  payload["reg_feed"]["url"]
    }
    changeset =
      %Account.RegFeed{}
      |> Account.RegFeed.changeset(params)
    opts = %{
      changeset: changeset,
    }
    {:noreply, assign(socket, opts)}
  end

  # if the feed exists, use that.
  # otherwise create a feed.
  # then create a register
  # finally, redirect to the reg/feed
  @impl true
  def handle_event("save", payload, socket) do
    reg_name  = payload["reg_feed"]["name"]
    feed_url  = payload["reg_feed"]["url"]
    folder_id = payload["reg_feed"]["folder_id"] |> String.to_integer()
    reg = Feedx.Api.SubTree.import_register(folder_id, reg_name, feed_url)
    send(self(), {"new_feed", %{reg_id: reg.id}})

    {:noreply, socket}
  end

end
