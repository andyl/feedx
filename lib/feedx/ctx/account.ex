defmodule Feedx.Ctx.Account do

  @moduledoc """
  Affordances for Account Resources
  """

  alias Feedx.Ctx.Account.{User, Folder, Register, ReadLog}
  alias Feedx.Ctx.News.{Post, Feed}
  alias Feedx.Repo
  import Ecto.Query

  # ----- users -----

  def user_list do
    Repo.all(User)
  end

  def user_get(user_id) do
    Repo.get(User, user_id)
  end

  def user_get_by(params) do
    Repo.get_by(User, params)
  end

  def user_get_by_email(email) do
    from(usr in User, where: fragment("email ilike ?", ^email))
    |> Repo.one()
  end

  def user_add(opts) do
    %User{}
    |> User.changeset(opts)
    |> Repo.insert()
  end

  def user_signup(opts) do
    %User{}
    |> User.signup_changeset(opts)
    |> Repo.insert()
  end

  def user_changeset(%User{} = user) do
    User.changeset(user, %{})
  end

  def user_change(_user_id) do
  end

  def user_change_pwd(_user_id, _newpwd) do
  end

  def user_delete(_user_id) do
  end

  def user_auth_by_email_and_pwd(email, pwd) do
    user = user_get_by_email(email)

    cond do
      user && Pbkdf2.verify_pass(pwd, user.hashed_password) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end

  # ----- tree -----

  # def cleantree(user_id) do
  #   rawtree(user_id)
  #   |> AltMap.retake([:id, :name, :user_id, :registers])
  # end
  #
  # def rawtree(user_id) do
  #   rq = from(r in Register, order_by: r.name, select: %{folder_id: r.folder_id, id: r.id, name: r.name})
  #
  #   from(
  #     f in Folder,
  #     where: f.user_id == ^user_id,
  #     order_by: f.name,
  #     preload: [registers: ^rq]
  #   )
  #   |> Repo.all()
  # end

  # ----- registers -----

  def register_get(id) do
    Repo.get(Register, id)
  end

  # ----- mark_all_for -----

  def mark_all_for(usrid) do
    mark_all_qry(usrid) |> create_read_logs()
  end

  def mark_all_for(usrid, fld_id: fldid) do
    from([pst, log, fee, reg, fld] in mark_all_qry(usrid),
      where: fld.id == ^fldid
    ) |> create_read_logs()
  end

  def mark_all_for(usrid, reg_id: regid) do
    from([pst, log, fee, reg, fld] in mark_all_qry(usrid),
      where: reg.id == ^regid
    ) |> create_read_logs()
  end

  def mark_all_for(usrid, pst_id: pstid) do
    from([pst, log, fee, reg, fld] in mark_all_qry(usrid),
      where: pst.id == ^pstid
    ) |> create_read_logs()
  end

  # ----- mark_all utility functions -----

  defp create_read_logs(list) do
    list
    |> Repo.all()
    |> Enum.map(&(create_read_log(&1)))
  end

  defp create_read_log(record) do
    %ReadLog{}
    |> ReadLog.changeset(record)
    |> Repo.insert()
  end

  defp mark_all_qry(userid) do
    from(pst in Post,
      left_join: log in ReadLog, on: pst.id == log.post_id,
      join:  fee in Feed       , on: pst.feed_id == fee.id,
      join:  reg in Register   , on: reg.feed_id == fee.id,
      join:  fld in Folder     , on: reg.folder_id == fld.id,
      where: fld.user_id == ^userid,
      where: is_nil(log.id),
      select: %{
        post_id: pst.id,
        register_id: reg.id,
        folder_id: fld.id,
        user_id: fld.user_id
      }
    )
  end

  # ----- utility functions -----

  @doc """
  Count number of elements in the database.
  """
  def count do
    %{
      user: count(User),
      folder: count(Folder),
      register: count(Register)
    }
  end

  def count(type) do
    from(element in type, select: count(element.id))
    |> Repo.one()
  end
end
