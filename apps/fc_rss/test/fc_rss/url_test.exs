defmodule FcRss.UrlTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias FcRss.Url

  doctest Url

  setup do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end

  describe "#pull/1" do
    test "with invalid url" do
      url_string = "asdf"
      url_struct = Url.pull(url_string)
      assert url_struct.url == url_string
      assert url_struct.valid_resp == false
      assert url_struct.valid_data == false
    end

    # test "with valid url, invalid data" do 
    #   use_cassette "pull_valid_resp_invalid_data" do
    #     FcHttp.start()
    #     url_string = "https://www.reddit.com/r/elixir"
    #     url_struct = Url.pull(url_string)
    #     assert url_struct.url == url_string
    #     assert url_struct.valid_resp == true
    #     assert url_struct.valid_data == false
    #     assert url_struct.data == %{}
    #   end
    # end
    #
    # test "with valid url, valid data" do
    #   use_cassette "pull_valid_resp_valid_data" do
    #     FcHttp.start()
    #     url_string = "https://www.reddit.com/r/elixir.rss"
    #     url_struct = Url.pull(url_string)
    #     assert url_struct.url == url_string
    #     assert url_struct.valid_resp == true
    #     assert url_struct.valid_data == true
    #     refute url_struct.data == %{}
    #   end
    # end
  end
end
