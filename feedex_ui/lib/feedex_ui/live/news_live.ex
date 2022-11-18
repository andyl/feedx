defmodule FeedexUi.NewsLive do
  @moduledoc """
  Renders the news page.
  """

  use FeedexUi, :live_view
  alias FeedexUi.Cache.UiState

  require Logger

  # ----- lifecycle callbacks -----

  @impl true
  def mount(_params, session, socket) do
    user = FeedexUi.SessionUtil.user_from_session(session)
    treemap = FeedexCore.Api.SubTree.cleantree(user.id)

    FeedexUi.Endpoint.subscribe("new_posts")

    opts = %{
      current_user: user,
      uistate: UiState.lookup(user.id),
      treemap: treemap,
      counts: gen_counts(user.id)
    }

    {:ok, assign(socket, opts)}
  end

  @impl true
  def handle_params(_unsigned_params, uri, socket) do
    {:noreply, assign(socket, path: URI.parse(uri).path)}
  end

  # ----- data helpers -----

  def gen_counts(user_id) do
    %{
      all: FeedexCore.Ctx.News.unread_count_for(user_id),
      fld: FeedexCore.Ctx.News.unread_aggregate_count_for(user_id, type: "fld"),
      reg: FeedexCore.Ctx.News.unread_aggregate_count_for(user_id, type: "reg")
    }
  end

  # ----- message handlers -----

  @impl true
  def handle_info({"set_uistate", %{uistate: new_state, recount: true}}, socket) do
    new_counts = gen_counts(socket.assigns.current_user.id)

    {:noreply, assign(socket, uistate: new_state, counts: new_counts)}
  end

  @impl true
  def handle_info({"set_uistate", %{uistate: new_state}}, socket) do
    {:noreply, assign(socket, uistate: new_state)}
  end

  @impl true
  def handle_info("mod_tree", socket) do
    user = socket.assigns.current_user

    treemap = FeedexCore.Api.SubTree.cleantree(user.id)

    new_opts = %{
      mode: "view",
      pst_id: nil,
      fld_id: nil,
      reg_id: nil
    }

    new_state =
      socket.assigns.uistate
      |> Map.merge(new_opts)

    opts = %{
      treemap: treemap,
      counts: gen_counts(user.id),
      uistate: new_state
    }

    {:noreply, assign(socket, opts)}
  end

  @impl true
  def handle_info("rename_folder", socket) do
    user = socket.assigns.current_user

    treemap = FeedexCore.Api.SubTree.cleantree(user.id)

    new_opts = %{
      mode: "view",
      pst_id: nil,
      reg_id: nil
    }

    new_state =
      socket.assigns.uistate
      |> Map.merge(new_opts)

    opts = %{
      treemap: treemap,
      uistate: new_state
    }

    {:noreply, assign(socket, opts)}
  end

  @impl true
  def handle_info("delete_folder", socket) do
    user = socket.assigns.current_user

    treemap = FeedexCore.Api.SubTree.cleantree(user.id)

    new_opts = %{
      mode: "view",
      pst_id: nil,
      fld_id: nil,
      reg_id: nil
    }

    new_state =
      socket.assigns.uistate
      |> Map.merge(new_opts)

    opts = %{
      treemap: treemap,
      uistate: new_state
    }

    {:noreply, assign(socket, opts)}
  end


  @impl true
  def handle_info("rename_feed", socket) do
    user = socket.assigns.current_user

    treemap = FeedexCore.Api.SubTree.cleantree(user.id)

    new_opts = %{
      mode: "view",
      pst_id: nil,
      fld_id: nil
    }

    new_state =
      socket.assigns.uistate
      |> Map.merge(new_opts)

    opts = %{
      treemap: treemap,
      uistate: new_state
    }

    {:noreply, assign(socket, opts)}
  end

  @impl true
  def handle_info({"delete_feed", %{fld_id: fld_id}}, socket) do

    user = socket.assigns.current_user

    treemap = FeedexCore.Api.SubTree.cleantree(user.id)

    new_opts = %{
      mode: "view",
      pst_id: nil,
      reg_id: nil,
      fld_id: fld_id
    }

    new_state =
      socket.assigns.uistate
      |> Map.merge(new_opts)

    opts = %{
      treemap: treemap,
      counts: gen_counts(user.id), 
      uistate: new_state
    }

    {:noreply, assign(socket, opts)}
  end

  @impl true
  def handle_info({"new_feed", %{reg_id: reg_id}}, socket) do

    user = socket.assigns.current_user

    treemap = FeedexCore.Api.SubTree.cleantree(user.id)

    new_opts = %{
      mode: "view",
      pst_id: nil,
      reg_id: reg_id,
      fld_id: nil
    }

    new_state =
      socket.assigns.uistate
      |> Map.merge(new_opts)

    opts = %{
      treemap: treemap,
      uistate: new_state
    }

    {:noreply, assign(socket, opts)}
  end

  @impl true
  def handle_info({"new_folder", %{fld_id: fld_id}}, socket) do

    user = socket.assigns.current_user

    treemap = FeedexCore.Api.SubTree.cleantree(user.id)

    new_opts = %{
      mode: "view",
      pst_id: nil,
      reg_id: nil,
      fld_id: fld_id
    }

    new_state =
      socket.assigns.uistate
      |> Map.merge(new_opts)

    opts = %{
      treemap: treemap,
      uistate: new_state
    }

    {:noreply, assign(socket, opts)}
  end

  @impl true
  def handle_info("refolder_feed", socket) do
    user = socket.assigns.current_user

    treemap = FeedexCore.Api.SubTree.cleantree(user.id)

    new_opts = %{
      mode: "view",
      pst_id: nil,
      fld_id: nil
    }

    new_state =
      socket.assigns.uistate
      |> Map.merge(new_opts)

    opts = %{
      treemap: treemap,
      uistate: new_state
    }

    {:noreply, assign(socket, opts)}
  end

  @impl true
  def handle_info("mark_all_read", socket) do
    opts = %{counts: gen_counts(socket.assigns.current_user.id)}
    {:noreply, assign(socket, opts)}
  end

  @impl true
  def handle_info("SYNC_FEED", socket) do

    user = socket.assigns.current_user

    Logger.info("RECEIVE SYNC_FEED")

    treemap = FeedexCore.Api.SubTree.cleantree(user.id)

    opts = %{
      treemap: treemap,
      counts: gen_counts(user.id),
    }

    {:noreply, assign(socket, opts)}
  end

  # @impl true
  # def handle_info(default, socket) do
  #   IO.inspect default, label: "DEFAULT PARAMS"
  #   IO.inspect socket, label: "DEFAULT SOCKET"
  #   {:noreply, socket}
  # end

end
