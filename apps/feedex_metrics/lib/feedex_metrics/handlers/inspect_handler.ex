defmodule FeedexMetrics.Handlers.InspectHandler do

  @moduledoc """
  Inspect Handler
  """

  @vm_memory [:vm, :memory]
  @vm_total_run_queue_lengths [:vm, :total_run_queue_lengths]
  @feedex_core_repo_query [:feedex_core, :repo, :query]
  @phoenix_endpoint_stop [:feedex, :endpoint, :stop]

  def setup do
    events = [
      @vm_memory, 
      @vm_total_run_queue_lengths, 
      @feedex_core_repo_query, 
      @phoenix_endpoint_stop
    ]

    :telemetry.attach_many(
      "inspect-handler",
      events,
      &handle_event/4,
      nil
    )
  end
  
  def handle_event(@vm_memory, measurements, metadata, _cfg) do
    output "+++++++++++++++++++++++++++++++++++++++"
    output @vm_memory
    output measurements
    output metadata 
    output "+++++++++++++++++++++++++++++++++++++++"
  end

  def handle_event(@vm_total_run_queue_lengths, measurements, metadata, _cfg) do
    output "======================================="
    output @vm_total_run_queue_lengths
    output measurements
    output metadata
    output "======================================="
  end

  def handle_event(@feedex_core_repo_query, measurements, metadata, _cfg) do
    output "+++++++++++++++++++++++++++++++++++++++"
    output @feedex_core_repo_query
    output measurements
    output metadata |> Map.drop([:query, :result, :params])
    output "+++++++++++++++++++++++++++++++++++++++"
  end

  def handle_event(@phoenix_endpoint_stop, measurements, metadata, _cfg) do
    output "======================================="
    output @phoenix_endpoint_stop
    output measurements
    output metadata
    output "======================================="
  end

  defp output(element) do
    element 
    |> inspect()
    |> IO.puts()
  end

end
