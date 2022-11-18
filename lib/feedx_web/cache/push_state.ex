defmodule FeedxWeb.Cache.PushState do

  alias FeedxWeb.Cache.UiState

  @moduledoc """
  Persistent store for User's PushState.

  The PushState is simply the user's UiState at a given moment in time, with a
  mostly-unique (we use a truncated hash string) hash value as a lookup key.

  The idea here is to post an updated UiState every time the user clicks on the
  LiveView page.  The reason we use a hash lookup instead of posting the
  UiState as URL params is that the full UiState is too long for a URL.

  - the uistate hash is posted as part of the browser url
  - the back button works
  - one UiState per hash

  Note that the usr_id is encoded in the UiState, preventing
  """

  @doc """
  Save the PushState

  Save a UiState into the store, and return the hash_key.
  """
  def save(ui_state) do
    hash_key = gen_hash(ui_state)

    sig()
    |> Pets.insert({hash_key, ui_state})

    hash_key
  end

  @doc """
  Return the PushState for a given lookup key.
  """
  def lookup(hash_key, usr_id \\ 1) do
    result = Pets.lookup(sig(), hash_key)

    case result do
      [] -> %UiState{usr_id: usr_id}
      nil -> %UiState{usr_id: usr_id}
      [{_, uistate}] -> uistate
      _ -> raise("Error: badval")
    end
  end

  @doc """
  Return all records.
  """
  def all do
    sig()
    |> Pets.all()
    |> Enum.map(&elem(&1, 1))
  end

  def cleanup do
    sig()
    |> Pets.cleanup()
  end

  def purge_old do
    sig()
    |> Pets.all()
    |> Enum.filter(&(&1))
    |> Enum.each(&(Pets.remove(sig(), elem(&1, 0))))
    :ok
  end

  @env Mix.env()
  defp sig do
    case @env do
      :dev ->  %{filepath: "/tmp/pushstate_dev.dat" , tablekey: :pushstate_dev}
      :test -> %{filepath: "/tmp/pushstate_test.dat", tablekey: :pushstate_test}
      :prod -> %{filepath: "/tmp/pushstate_prod.dat", tablekey: :pushstate_prod}
    end
  end

  # the hash_key is truncated, for brevity as a the browser Url
  # we expect a small number of pushStates per user
  # so the risk of cross-user collision is small
  # note also that the usr_id is encoded in the push_state
  defp gen_hash(ui_state) do
    :md5
    |> :crypto.hash(inspect(ui_state))
    |> Base.url_encode64(padding: false)
    |> String.slice(1..6)
  end
end
