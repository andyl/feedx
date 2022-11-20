defmodule FeedxWeb.BodyAddFolderComponent do
  @moduledoc """
  Renders the body add folder component.

  Call using:

      <%= live_component(FeedxWeb.BodyAddFolderComponent, uistate: @uistate) %>

  """

  alias Feedx.Ctx.Account
  alias Feedx.Api

  import FeedxWeb.CoreComponents

  # import Phoenix.HTML.Form

  # import FeedxWeb.ErrorHelpers

  use Phoenix.LiveComponent

  # import FeedxWeb.IconHelpers

  # ----- lifecycle callbacks -----

  @impl true
  def update(session, socket) do
    opts = %{
      changeset: Account.Folder.new_changeset(),
      uistate: session.uistate
    }

    {:ok, assign(socket, opts)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
    <div class="font-bold">Create a new Folder</div>
      <div>
        <.simple_form :let={f} for={@changeset} phx-target={@myself} phx-change="validate" phx-submit="save">
          <.input field={{f, :name}} label="Folder Name" />
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

  # ----- event handlers -----

  @impl true
  def handle_event("validate", payload, socket) do
    changeset =
      payload["folder"]["name"]
      |> Api.Folder.folder_validation_changeset()

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", payload, socket) do
    userid = socket.assigns.uistate.usr_id
    name = payload["folder"]["name"]
    folder = Api.Folder.find_or_create_folder(userid, name)

    send(self(), {"new_folder", %{fld_id: folder.id}})
    {:noreply, socket}
  end
end
