defmodule FeedexCore.Ctx.News do

  @moduledoc """
  Affordance for News Resources
  """

  alias FeedexCore.Ctx.News.{Feed, Post}
  alias FeedexCore.Ctx.Account.{ReadLog, Register, Folder}
  alias FeedexCore.Repo

  import Ecto.Query

  # ----- feeds -----

  def feed_get(id) do
    Repo.get(Feed, id)
  end

  # ----- post query -----

  def get_post(id) do
    Repo.get(Post, id)
  end

  # ----- unread aggregates -----

  def unread_aggregate_count_for(userid, type: "fld") do
    from([pst, log, fee, reg, fld] in unread_aggregate_count_qry(userid),
      group_by: fld.id,
      select: %{fld.id => count(pst.id)}
    ) 
    |> Repo.all() 
    |> Enum.reduce(%{}, fn(el, acc) -> Map.merge(acc, el) end)
  end

  def unread_aggregate_count_for(userid, type: "reg") do
    from([pst, log, fee, reg, fld] in unread_aggregate_count_qry(userid),
      group_by: reg.id,
      select: %{reg.id => count(pst.id)}
    ) 
    |> Repo.all() 
    |> Enum.reduce(%{}, fn(el, acc) -> Map.merge(acc, el) end)
  end

  def unread_aggregate_count_qry(userid) do
    # from(pst in Post,
    q1 = from(p in Post, distinct: :title, order_by: [desc: :id])
    from(pst in subquery(q1),
      left_join: log in ReadLog, on: pst.id == log.post_id,
      join:  fee in Feed       , on: pst.feed_id == fee.id,
      join:  reg in Register   , on: reg.feed_id == fee.id,
      join:  fld in Folder     , on: reg.folder_id == fld.id,
      where: fld.user_id == ^userid,
      where: not fragment("? ~* ?", pst.title, fld.stopwords),
      or_where: is_nil(fld.stopwords),
      where: is_nil(log.id) 
    )
  end
  
  # ----- unread_count -----

  def unread_count(uistate) do
    case {uistate.reg_id, uistate.fld_id} do
      {nil, nil} -> unread_count_for(uistate.usr_id)
      {regid, nil} -> unread_count_for(uistate.usr_id, reg_id: regid)
      {nil, fldid} -> unread_count_for(uistate.usr_id, fld_id: fldid)
    end
  end

  # ----- unread_count_for -----

  def unread_count_for(userid) do
    unread_count_qry(userid) |> Repo.one()
  end

  def unread_count_for(userid, fld_id: fldid) do
    from([pst, log, fee, reg, fld] in unread_count_qry(userid),
      where: fld.id == ^fldid
    ) |> Repo.one()
  end

  def unread_count_for(userid, reg_id: regid) do
    from([pst, log, fee, reg, fld] in unread_count_qry(userid),
      where: reg.id == ^regid
    ) |> Repo.one()
  end

  defp unread_count_qry(userid) do
    q1 = from(p in Post, distinct: :title, order_by: [desc: :id])
    from(pst in subquery(q1),
      left_join: log in ReadLog, on: pst.id == log.post_id,
      join:  fee in Feed       , on: pst.feed_id == fee.id,
      join:  reg in Register   , on: reg.feed_id == fee.id,
      join:  fld in Folder     , on: reg.folder_id == fld.id,
      where: fld.user_id == ^userid,
      where: not fragment("? ~* ?", pst.title, fld.stopwords),
      or_where: is_nil(fld.stopwords),
      where: is_nil(log.id), 
      select: count(pst.id)
    )
  end

  # ----- posts_for -----

  def posts_for(userid) do
    posts_qry(userid) |> Repo.all()
  end

  def posts_for(usrid, fld_id: fldid) do
    from([pst, log, fee, reg, fld] in posts_qry(usrid),
      where: fld.id == ^fldid
    ) |> Repo.all()
  end

  def posts_for(usrid, reg_id: regid) do
    from([pst, log, fee, reg, fld] in posts_qry(usrid),
      where: reg.id == ^regid
    ) |> Repo.all()
  end

  defp posts_qry(user_id) do
    # use subquery to eliminate duplicate titles (forum posts) only show the latest
    # from(pst in Post,
    q1 = from(p in Post, distinct: :title, order_by: [desc: :id])
    from(pst in subquery(q1),
      left_join: log in ReadLog, on: pst.id == log.post_id,
      join:  fee in Feed       , on: pst.feed_id == fee.id,
      join:  reg in Register   , on: reg.feed_id == fee.id,
      join:  fld in Folder     , on: reg.folder_id == fld.id,
      where: fld.user_id == ^user_id,
      where: not fragment("? ~* ?", pst.title, fld.stopwords),
      or_where: is_nil(fld.stopwords),
      order_by: [desc: pst.id],
      limit: 100,
      select: %{
        id:         pst.id,
        exid:       pst.exid,
        title:      pst.title,
        body:       pst.body,
        author:     pst.author,
        link:       pst.link,
        fld_name:   fld.name,
        fld_id:     fld.id,
        reg_name:   reg.name,
        reg_id:     reg.id,
        updated_at: pst.updated_at,
        read_log:   log.id
      }
    )
  end
end
