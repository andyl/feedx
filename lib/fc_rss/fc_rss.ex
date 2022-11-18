defmodule FcRss do
  @moduledoc """
  An Elixir Client that pulls RSS Documents.
  """

  alias FcRss.Url

  @doc """
  Scan for a valid RSS feed.

  Returns the URL of a valid RSS feed.

  If the input URL does not return a valid RSS document, a number of
  alternative URL's are scanned, and the URL of the first valid URL is returned.

  For example: given an input URL "http://feedex.io/myfeed.html", the following URLs will
  be tested:

  - http://feedex.io/myfeed.rss
  - http://feedex.io/myfeed/feed

  Use this function when someone adds a new URL to the RSS aggregator.  Store
  the returned URL for use when polling with `get/1`.

  ## Examples

      iex> FcRss.probe("https://notvalid.io")
      {:error, "Bad URL"}

  """
  def scan(url) do
    url
    |> url_list()
    |> pull_urls()
    |> classify_urls()
    |> select_valid_url()
  end

  @doc """
  Gets XML data for an RSS feed.

  Unlike `scan/1`, this function only retrieves RSS data for the given URL.

  Use this function when polling the URL for updates.

  ## Examples

      iex> FcRss.get("https://invalid_url.io/feed")
      {:error, "Bad URL"}

  """
  def get(url) do
    [url]
    |> pull_urls()
    |> classify_urls()
    |> select_valid_url()
  end

  defp url_list(url) do
    [url]
  end

  defp pull_urls(url_list) do
    url_list
    |> Enum.map(&Url.pull(&1))
  end

  defp classify_urls(url_list) do
    %{
      has_valid_resp: Enum.find(url_list, fn el -> el.valid_resp end),
      has_valid_data: Enum.find(url_list, fn el -> el.valid_data end),
      url_list: url_list
    }
  end

  defp select_valid_url(%{has_valid_resp: nil}) do
    {:error, "Bad URL"}
  end

  defp select_valid_url(%{has_valid_data: nil}) do
    {:error, "Not an RSS feed"}
  end

  defp select_valid_url(url_classifier) do
    url =
      url_classifier.url_list
      |> Enum.find(fn el -> el.valid_resp && el.valid_data end)

    {:ok, url.url, url.data}
  end
end
