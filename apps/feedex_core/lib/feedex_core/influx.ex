defmodule FeedexCore.Influx do

  def write_point(measurement, vals, tags) do
    tagstr = Enum.map(tags, fn({k,v}) -> "#{k}=#{v}" end) |> Enum.join(",")
    valstr = Enum.map(vals, fn({k,v}) -> "#{k}=#{v}" end) |> Enum.join(",")
    "#{measurement},#{tagstr} #{valstr}"
    |> send()
  end

  # async send, fire and forget
  def send(body) do
    db  = Application.get_env(:feedex_core, FeedexCore.Influx)[:database]
    _url = "localhost:8086/write?db=#{db}&time_precision=s"
    _opt = [body: body, basic_auth: {"admin", "admin"}]
    :ok 
    # Task.start(fn -> HTTPotion.post(url, opt) end)
  end
end
