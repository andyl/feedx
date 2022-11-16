defmodule FeedexUi.Cache.UiState do
  # modes: view, edit, add_feed, add_folder, edit_feed, edit_folder

  defstruct mode: "view",
            usr_id: nil,
            fld_id: nil,
            reg_id: nil,
            pst_id: nil,
            timestamp: DateTime.utc_now()

  alias FeedexUi.Cache.UiState

  @moduledoc """
  Persistent store for User's UiState.

  One record per userid.
  """

  @doc """
  Save the UiState

  Every time a link is accesses, save an event-payload into the log-store.
  """
  def save(state = %{}) do
    payload = struct(UiState, state)

    sig()
    |> Pets.insert({payload.usr_id, payload})
  end

  @doc """
  Return the UiState for a given usr_id.
  """
  def lookup(usr_id) do
    result = Pets.lookup(sig(), usr_id)

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

  @env Mix.env()
  defp sig do
    case @env do
      :dev -> %{filepath: "/tmp/uistate_dev.dat", tablekey: :uistate_dev}
      :test -> %{filepath: "/tmp/uistate_test.dat", tablekey: :uistate_test}
      :prod -> %{filepath: "/tmp/uistate_prod.dat", tablekey: :uistate_prod}
    end
  end
end
