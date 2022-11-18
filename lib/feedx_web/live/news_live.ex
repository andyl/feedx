defmodule FeedxWeb.NewsLive do
  @moduledoc """
  Renders the news page.
  """

  use FeedxWeb, :live_view
  alias FeedxWeb.Cache.UiState

  require Logger

  # ----- HEEX -----

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-[150px_600px] w-full">
      <div class="pl-3 bg-slate-400">
        <div>
          <%= live_render(@socket, FeedxWeb.ClockLive, id: "clock") %>
        </div>
        <div>
          <%= live_component(@socket, FeedxWeb.TreeComponent, id: "tre", uistate: @uistate, treemap: @treemap, counts: @counts) %>
        </div>
        <div>
          <%= live_component(@socket, FeedxWeb.BtnComponent, id: "btn", uistate: @uistate) %>
        </div>
      </div>
      <div>
        <div class="bg-slate-400">
          <%= live_component(@socket, FeedxWeb.HdrComponent, id: "hdr", uistate: @uistate, treemap: @treemap, counts: @counts) %>
        </div>
        <div>
          BODY
          <%# live_component(@socket, FeedexUi.BodyComponent, id: "bdy", uistate: @uistate, counts: @counts) %>
        </div>
      </div>
    </div>
    """
  end

  # ----- lifecycle callbacks -----

  @impl true
  def mount(_params, session, socket) do
    user = FeedxWeb.SessionUtil.user_from_session(session)
    treemap = Feedx.Api.SubTree.cleantree(user.id)

    FeedxWeb.Endpoint.subscribe("new_posts")

    opts = %{
      email: live_flash(socket.assigns.flash, :email),
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
      all: Feedx.Ctx.News.unread_count_for(user_id),
      fld: Feedx.Ctx.News.unread_aggregate_count_for(user_id, type: "fld"),
      reg: Feedx.Ctx.News.unread_aggregate_count_for(user_id, type: "reg")
    }
  end

  # ----- message handlers -----

  # @impl true
  # def handle_info({"set_uistate", %{uistate: new_state, recount: true}}, socket) do
  #   new_counts = gen_counts(socket.assigns.current_user.id)
  #
  #   {:noreply, assign(socket, uistate: new_state, counts: new_counts)}
  # end
  #
  # @impl true
  # def handle_info({"set_uistate", %{uistate: new_state}}, socket) do
  #   {:noreply, assign(socket, uistate: new_state)}
  # end
  #
  # @impl true
  # def handle_info("mod_tree", socket) do
  #   user = socket.assigns.current_user
  #
  #   treemap = FeedexCore.Api.SubTree.cleantree(user.id)
  #
  #   new_opts = %{
  #     mode: "view",
  #     pst_id: nil,
  #     fld_id: nil,
  #     reg_id: nil
  #   }
  #
  #   new_state =
  #     socket.assigns.uistate
  #     |> Map.merge(new_opts)
  #
  #   opts = %{
  #     treemap: treemap,
  #     counts: gen_counts(user.id),
  #     uistate: new_state
  #   }
  #
  #   {:noreply, assign(socket, opts)}
  # end
  #
  # @impl true
  # def handle_info("rename_folder", socket) do
  #   user = socket.assigns.current_user
  #
  #   treemap = FeedexCore.Api.SubTree.cleantree(user.id)
  #
  #   new_opts = %{
  #     mode: "view",
  #     pst_id: nil,
  #     reg_id: nil
  #   }
  #
  #   new_state =
  #     socket.assigns.uistate
  #     |> Map.merge(new_opts)
  #
  #   opts = %{
  #     treemap: treemap,
  #     uistate: new_state
  #   }
  #
  #   {:noreply, assign(socket, opts)}
  # end
  #
  # @impl true
  # def handle_info("delete_folder", socket) do
  #   user = socket.assigns.current_user
  #
  #   treemap = FeedexCore.Api.SubTree.cleantree(user.id)
  #
  #   new_opts = %{
  #     mode: "view",
  #     pst_id: nil,
  #     fld_id: nil,
  #     reg_id: nil
  #   }
  #
  #   new_state =
  #     socket.assigns.uistate
  #     |> Map.merge(new_opts)
  #
  #   opts = %{
  #     treemap: treemap,
  #     uistate: new_state
  #   }
  #
  #   {:noreply, assign(socket, opts)}
  # end
  #
  #
  # @impl true
  # def handle_info("rename_feed", socket) do
  #   user = socket.assigns.current_user
  #
  #   treemap = FeedexCore.Api.SubTree.cleantree(user.id)
  #
  #   new_opts = %{
  #     mode: "view",
  #     pst_id: nil,
  #     fld_id: nil
  #   }
  #
  #   new_state =
  #     socket.assigns.uistate
  #     |> Map.merge(new_opts)
  #
  #   opts = %{
  #     treemap: treemap,
  #     uistate: new_state
  #   }
  #
  #   {:noreply, assign(socket, opts)}
  # end
  #
  # @impl true
  # def handle_info({"delete_feed", %{fld_id: fld_id}}, socket) do
  #
  #   user = socket.assigns.current_user
  #
  #   treemap = FeedexCore.Api.SubTree.cleantree(user.id)
  #
  #   new_opts = %{
  #     mode: "view",
  #     pst_id: nil,
  #     reg_id: nil,
  #     fld_id: fld_id
  #   }
  #
  #   new_state =
  #     socket.assigns.uistate
  #     |> Map.merge(new_opts)
  #
  #   opts = %{
  #     treemap: treemap,
  #     counts: gen_counts(user.id),
  #     uistate: new_state
  #   }
  #
  #   {:noreply, assign(socket, opts)}
  # end
  #
  # @impl true
  # def handle_info({"new_feed", %{reg_id: reg_id}}, socket) do
  #
  #   user = socket.assigns.current_user
  #
  #   treemap = FeedexCore.Api.SubTree.cleantree(user.id)
  #
  #   new_opts = %{
  #     mode: "view",
  #     pst_id: nil,
  #     reg_id: reg_id,
  #     fld_id: nil
  #   }
  #
  #   new_state =
  #     socket.assigns.uistate
  #     |> Map.merge(new_opts)
  #
  #   opts = %{
  #     treemap: treemap,
  #     uistate: new_state
  #   }
  #
  #   {:noreply, assign(socket, opts)}
  # end
  #
  # @impl true
  # def handle_info({"new_folder", %{fld_id: fld_id}}, socket) do
  #
  #   user = socket.assigns.current_user
  #
  #   treemap = FeedexCore.Api.SubTree.cleantree(user.id)
  #
  #   new_opts = %{
  #     mode: "view",
  #     pst_id: nil,
  #     reg_id: nil,
  #     fld_id: fld_id
  #   }
  #
  #   new_state =
  #     socket.assigns.uistate
  #     |> Map.merge(new_opts)
  #
  #   opts = %{
  #     treemap: treemap,
  #     uistate: new_state
  #   }
  #
  #   {:noreply, assign(socket, opts)}
  # end
  #
  # @impl true
  # def handle_info("refolder_feed", socket) do
  #   user = socket.assigns.current_user
  #
  #   treemap = FeedexCore.Api.SubTree.cleantree(user.id)
  #
  #   new_opts = %{
  #     mode: "view",
  #     pst_id: nil,
  #     fld_id: nil
  #   }
  #
  #   new_state =
  #     socket.assigns.uistate
  #     |> Map.merge(new_opts)
  #
  #   opts = %{
  #     treemap: treemap,
  #     uistate: new_state
  #   }
  #
  #   {:noreply, assign(socket, opts)}
  # end
  #
  # @impl true
  # def handle_info("mark_all_read", socket) do
  #   opts = %{counts: gen_counts(socket.assigns.current_user.id)}
  #   {:noreply, assign(socket, opts)}
  # end
  #
  # @impl true
  # def handle_info("SYNC_FEED", socket) do
  #
  #   user = socket.assigns.current_user
  #
  #   Logger.info("RECEIVE SYNC_FEED")
  #
  #   treemap = FeedexCore.Api.SubTree.cleantree(user.id)
  #
  #   opts = %{
  #     treemap: treemap,
  #     counts: gen_counts(user.id),
  #   }
  #
  #   {:noreply, assign(socket, opts)}
  # end

  # @impl true
  # def handle_info(default, socket) do
  #   IO.inspect default, label: "DEFAULT PARAMS"
  #   IO.inspect socket, label: "DEFAULT SOCKET"
  #   {:noreply, socket}
  # end




















end
