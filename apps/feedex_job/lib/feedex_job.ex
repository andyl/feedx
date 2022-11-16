defmodule FeedexJob do
  alias FeedexCore.Repo
  alias FeedexCore.Ctx.Account.Register
  alias FeedexCore.Ctx.Account.Folder
  alias FeedexCore.Ctx.News.Post
  alias FeedexCore.Ctx.News.Feed

  require Logger

  import Ecto.Query

  @moduledoc """
  Fetches post data for an RSS feed.
  """

  @doc """
  Runs with max frequency once every five minutes.
  """
  def safe_sync(feed) do
    delta = Timex.diff(Timex.now(), feed.updated_at, :minutes)
    if delta > 5 || feed.sync_count == 0 do
      status = sync(feed)
      Phoenix.PubSub.broadcast_from(Feedex.PubSub, self(), "new_posts", "SYNC_FEED")
      Logger.info "BROADCAST SYNC_FEED (status: #{status})"
    else
      Logger.info "----- FEED SYNC SKIPPED ------------------"
      Logger.info "  FEED ID: #{feed.id}"
      Logger.info " FEED URL: #{String.slice(feed.url, 0..35)}"
      Logger.info " NUM SYNC: #{feed.sync_count}"
      Logger.info "LAST SYNC: #{feed.updated_at}"
      Logger.info " TIME NOW: #{Timex.now()}"
      Logger.info "    DELTA: #{delta} (LESS THAN 5 MINS)"
      Logger.info "----- FEED SYNC SKIPPED ------------------"
    end
  end

  @doc """
  Fetch data from URL, update Post records.
  """
  def sync(feed) do
    Logger.info "----- FEED SYNC --------------------------"
    Logger.info "  FEED ID: #{feed.id}"
    Logger.info " FEED URL: #{String.slice(feed.url, 0..35)}"
    Logger.info " NUM SYNC: #{feed.sync_count}"
    Logger.info "LAST SYNC: #{feed.updated_at}"
    Logger.info " TIME NOW: #{Timex.now()}"
    Logger.info "    DELTA: #{Timex.diff(Timex.now(), feed.updated_at, :minutes)}"
    Logger.info "----- FEED SYNC --------------------------"
    touch(feed)
    case FcRss.scan(feed.url) do
      {:ok, _url, data} -> sync_posts(feed, data)
      {:error, message} -> {:error, message}
    end
  end

  @doc """
  Invoked by the cron scheduler.  (typically once every five minutes)

  Syncs the oldest feed, and touches the feed's `updated_at` timestamp.
  """
  def sync_next do
    Feed
    |> order_by(:updated_at)
    |> limit(1)
    |> Repo.one()
    |> safe_sync()
  end

  # ----- invoked from the UI -----

  def sync_for(usrid) do
    sync_qry(usrid) 
    |> Repo.all() 
    |> Enum.map(&(safe_sync(&1)))
  end

  def sync_for(usrid, fld_id: fldid) do
    from([fee, reg, fld] in sync_qry(usrid),
      where: fld.id == ^fldid) 
    |> Repo.all()
    |> Enum.map(&(safe_sync(&1)))
  end

  def sync_for(usrid, reg_id: regid) do
    from([fee, reg, fld] in sync_qry(usrid),
      where: reg.id == ^regid) 
    |> Repo.all()
    |> Enum.map(&(safe_sync(&1)))
  end

  defp sync_qry(userid) do
    from(fee in Feed,
      join:  reg in Register, on: reg.feed_id == fee.id,
      join:  fld in Folder  , on: reg.folder_id == fld.id,
      where: fld.user_id == ^userid,
      order_by: [desc: fee.updated_at]
    )
  end

  # ----- for development and testing -----
  
  def sync_all do
    Feed
    |> order_by(:updated_at)
    |> Repo.all()
    |> Enum.map(&(safe_sync(&1)))
  end

  # ----- utility functions -----

  defp touch(feed) do
    from(f in Feed, 
      update: [inc: [sync_count: 1]], 
      update: [set: [updated_at: ^Timex.now()]], 
      where: f.id == ^feed.id
    ) |> Repo.update_all([])
  end

  # TODO: bulk-update (Repo.insert_all)
  defp sync_posts(feed, data) do
    data.entries 
    |> Enum.reverse()
    |> Enum.each(&(sync_post(feed.id, &1)))
    :ok
  end

  defp sync_post(feed_id, post) do
    opts = %Post{
      exid:    post.id,
      title:   post.title,
      body:    post[:description] || post[:content],
      author:  author_for(post),
      link:    link_for(post),
      feed_id: feed_id
    }
    Repo.get_by(Post, exid: opts.exid) || Repo.insert!(opts)
  end

  defp author_for(post) do
    post[:author] || Enum.join(post[:authors] || [])
  end

  defp link_for(post) do
    post[:"rss2:link"] || List.first(post[:links] || [])
  end
end
