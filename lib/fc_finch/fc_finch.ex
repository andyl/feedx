defmodule FcFinch do
  @moduledoc """
  Finch HTTP Client
  """

  @doc """
  Post to a URL
  """
  def post(url) do
    Finch.build(:post, url)
    |> Finch.request(FcFinch.App)
  end

  @doc """
  Get from a URL
  """
  def get(url) do
    Finch.build(:get, url)
    |> Finch.request(FcFinch.App)
  end

  def hello do
    "world"
  end

  def success?(%Finch.Response{status: code}) do
    code in 200..299
  end

  def success?(_unknown) do
    false
  end
end
