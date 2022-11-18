defmodule FeedxWeb.SessionUtil do
  @moduledoc """
  Conveniences for use with Session infomation within LiveViews.
  """

  @doc """
  Returns the user for a session that contains a user token.
  """
  def user_from_session(session) do
    session["user_token"]
    |> Feedx.Accounts.get_user_by_session_token()
  end
end
