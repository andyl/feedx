defmodule FcTesla.Base do
  @moduledoc """
  Documentation for `FcTesla`.
  """

  use Tesla

  plug Tesla.Middleware.FollowRedirects

  def fc_post(url, opt \\ []) do
    case post(url, opt) do
      {:ok, response} -> response
      error -> error
    end
  end

  def fc_get(url, opt \\ []) do
    case get(url, opt) do
      {:ok, response} -> response
      error -> error
    end
  end

  def fc_success?(%Tesla.Env{status: code}) do
    code in 200..299
  end

  def fc_success?(_unknown) do
    false
  end
end
