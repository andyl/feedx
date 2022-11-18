defmodule FcTesla do
  @moduledoc """
  Documentation for `FcTesla`.
  """

  def influx_post(db, line) do
    FcTesla.InfluxV1.influx_post(db, line)
  end

  def fc_get(url, opt \\ []) do
    case FcTesla.Base.get(url, opt) do
      {:ok, resp} -> resp
      alt -> alt
    end
  end

  def fc_success?(%Tesla.Env{status: code}) do
    code in 200..299
  end

  def fc_success?(_unknown) do
    false
  end
end
