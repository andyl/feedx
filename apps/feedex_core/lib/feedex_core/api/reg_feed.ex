defmodule FeedexCore.Api.RegFeed do
  @moduledoc """
  Utilities for working with RegFeeds
  """

  alias FeedexCore.Ctx.Account.Register
  alias FeedexCore.Ctx.News.Feed
  alias FeedexCore.Repo

  def find_or_create_regfeed(fld_id, reg_name, feed_url) do
    feed = find_or_create_feed(feed_url) 
    find_or_create_reg(feed.id, fld_id, reg_name) 
  end

  defp find_or_create_feed(url) do
    find_feed(url) || create_feed(url)
  end

  defp find_feed(url) do
    Repo.get_by(Feed, url: url) 
  end

  defp create_feed(url) do
    {:ok, feed} = %Feed{url: url} |> Repo.insert() 
    feed
  end

  defp find_or_create_reg(feed_id, fld_id, reg_name) do
    result = find_reg(feed_id, fld_id, reg_name) || create_reg(feed_id, fld_id, reg_name)
    result 
  end

  def find_reg(feed_id, folder_id, reg_name) do
    Repo.get_by(Register, feed_id: feed_id, folder_id: folder_id, name: reg_name) 
  end

  def create_reg(feed_id, folder_id, reg_name) do
    {:ok, reg} = %Register{name: reg_name, feed_id: feed_id, folder_id: folder_id} 
                 |> Repo.insert() 
    reg
  end

end
