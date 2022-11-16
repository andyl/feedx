defmodule FcRss.Url do
  @moduledoc """
  Pulls and validates RSS data.
  """

  alias FcRss.Url

  defstruct url: "", valid_resp: false, resp: %{}, valid_data: false, data: %{}

  @doc """
  Pulls data and returns Url struct.

  This function checks two conditions:
  1) is the url valid?
  2) does the response body contain valid RSS/Atom XML?
  """
  def pull(input_url) do
    input_url
    |> download()
    |> parse()
  end

  defp download(input_url) do
    resp = FcTesla.fc_get(input_url)
    succ = FcTesla.fc_success?(resp)
    %{%Url{} | url: input_url, resp: resp, valid_resp: succ}
  end

  defp parse(url_data = %Url{valid_resp: false}) do
    url_data
  end

  defp parse(url_data) do
    case ElixirFeedParser.parse(url_data.resp.body) do
      {:ok, data} -> %{url_data | valid_data: true, data: data}
      {:error, _} -> url_data
    end
  end
end
