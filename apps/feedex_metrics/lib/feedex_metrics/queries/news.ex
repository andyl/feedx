defmodule FeedexMetrics.Queries.NewsQuery do

  @moduledoc """
  Queries for FeedexCore.News
  """

  alias FeedexCore.Ctx.News.Post
  alias FeedexCore.Ctx.Account
  alias FeedexCore.Ctx.News

  alias FeedexCore.Repo

  import Ecto.Query

  @doc """
  Return a metric tuple with number of posts

  Tuple elements: {metric, fields, tags}

  Eg:

      {"post_count", %{total: <count>, unread: <count>}, %{host: <host>}}

  """
  def post_counts do
    user = Account.user_get_by_email("aaa@aaa.com")
    all_pst_count = from(pst in Post, select: count(pst.id)) |> Repo.one()
    unr_pst_count = News.unread_count_for(user.id)
    {:ok, host} = :inet.gethostname()

    metric = "post_count"
    fields = %{total: all_pst_count, unread: unr_pst_count}
    tags = %{host: host}

    {metric, fields, tags}
  end
end
