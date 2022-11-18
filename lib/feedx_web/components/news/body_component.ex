defmodule FeedxWeb.BodyComponent do
  @moduledoc """
  Renders the btn component.

  Call using:

      <%= live_component(FeedexUi.BodyComponent, uistate: @uistate) %>

  """

  use Phoenix.LiveComponent

  alias FeedxWeb.{BodyAddFeedComponent, BodyAddFolderComponent}
  alias FeedxWeb.{BodyEditFeedComponent, BodyEditFolderComponent}
  alias FeedxWeb.{BodyViewComponent}

  def render(assigns) do
    ~H"""
    <div class="px-2 pt-1 bg-white">
      <%= render_body(@socket, @counts, @uistate) %>
    </div>
    """
  end

  # ----- view helpers -----

  def render_body(socket, counts, uistate) do
    # without this if-statement, there is a compiler warning: `socket` variable is not used. Hmm...
    if socket do
      case uistate.mode do
        "view"        -> live_component(BodyViewComponent,       opts(counts, uistate, "view"))
        "add_feed"    -> live_component(BodyAddFeedComponent,    opts(counts, uistate, "afee"))
        "add_folder"  -> live_component(BodyAddFolderComponent,  opts(counts, uistate, "afol"))
        "edit_feed"   -> live_component(BodyEditFeedComponent,   opts(counts, uistate, "efee"))
        "edit_folder" -> live_component(BodyEditFolderComponent, opts(counts, uistate, "efol"))
        _             -> live_component(BodyViewComponent,       opts(counts, uistate, "view"))
      end
    end
  end

  def opts(counts, uistate, element) do
    num = Enum.random(100_000..999_999)
    [counts: counts, uistate: uistate, id: "#{element}_#{num}"]
  end

end
