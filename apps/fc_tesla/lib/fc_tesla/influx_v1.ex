defmodule FcTesla.InfluxV1 do
  @moduledoc """
  Utilities for posting metrics to InfluxDB V1.
  """

  use Tesla

  plug Tesla.Middleware.FormUrlencoded
  plug Tesla.Middleware.BasicAuth, 
    username: db_username(), password: db_password()

  def influx_post(db, line) do
    body = line
    url  = "http://localhost:8086/write?db=#{db}&time_precision=s"
    case post(url, body) do
      {:ok, response} -> response
      error -> error
    end
  end

  def success?(%Tesla.Env{status: code}) do
    code in 200..299
  end

  def success?(_unknown) do
    false
  end

  defp db_username do
    Application.get_env(:feedex_tsdb, FeedexTsdb)[:username] || "admin"
  end

  defp db_password do
    Application.get_env(:feedex_tsdb, FeedexTsdb)[:password] || "admin"
  end
end
