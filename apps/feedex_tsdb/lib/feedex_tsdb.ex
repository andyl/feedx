defmodule FeedexTsdb do

  @moduledoc """
  TSDB Api
  """

  @doc """
  Writes a point to the TSDB

  example:
      write_point("post_count", %{total: 2343, unread: 222}, %{host: "myhost"})

  """
  def write_point(measurement, flds, tags) do
    tagstr = Enum.map(tags, fn({k, v}) -> "#{k}=#{v}" end) |> Enum.join(",")
    fldstr = Enum.map(flds, fn({k, v}) -> "#{k}=#{v}" end) |> Enum.join(",")
    "#{measurement},#{tagstr} #{fldstr}"
    |> send()
  end

  # async send, fire and forget
  def send(line) do
    db = Application.get_env(:feedex_tsdb, FeedexTsdb)[:database]
    Task.start(fn -> FcTesla.influx_post(db, line) end)
  end

end
