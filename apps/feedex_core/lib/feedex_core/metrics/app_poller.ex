# defmodule FeedexCore.Metrics.AppPoller do
#   
#   @moduledoc """
#   Periodically write stats.
#   """
#
#   alias FeedexCore.Ctx.News.Post
#   alias FeedexCore.Ctx.Account
#   alias FeedexCore.Ctx.News
#
#   alias FeedexCore.Repo
#
#   import Ecto.Query
#
#   def post_counts do
#     user = Account.user_get_by_email("aaa@aaa.com")
#     all_pst_count = from(pst in Post, select: count(pst.id)) |> Repo.one()
#     unr_pst_count = News.unread_count_for(user.id)
#     {:ok, host} = :inet.gethostname()
#
#     metric = "post_count"
#     fields = %{total: all_pst_count, unread: unr_pst_count}
#     tags = %{host: host}
#
#     IO.puts "Metrics - COUNTS #{inspect({metric, fields, tags})}"
#     FeedexTsdb.write_point(metric, fields, tags)
#   end
# end
