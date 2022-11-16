defmodule FeedexCore.Metrics.InfluxHandler do

  alias FeedexCore.Influx

  def setup do
    events = [
      [:vm, :memory],
      [:vm, :total_run_queue_lengths],
      [:phoenix, :endpoint, :stop],
      [:feedex_core, :repo, :query]
    ]

    # IO.inspect "======================================="
    # IO.inspect "STARTING INFLUX TELEMETRY"
    # IO.inspect events
    # IO.inspect "======================================="

    :telemetry.attach_many(
      "influx-handler",
      events,
      &handle_event/4,
      nil
    )
  end

  def handle_event([:vm, :memory], fields, _metadata, _cfg) do
    measurement = "vm_memory"
    {:ok, host} = :inet.gethostname()
    Influx.write_point(measurement, fields, %{host: host})
  end

  def handle_event([:vm, :total_run_queue_lengths], fields, _metadata, _cfg) do
    measurement = "vm_total_run_queue_lengths"
    {:ok, host} = :inet.gethostname()
    Influx.write_point(measurement, fields, %{host: host})
  end

  def handle_event([:feedex_core, :repo, :query], fields, _metadata, _cfg) do
    measurement = "feedex_core_repo_query"
    {:ok, host} = :inet.gethostname()
    tags = %{
      host: host
    }
    Influx.write_point(measurement, fields, tags)
  end

  def handle_event([:phoenix, :endpoint, :stop], fields, params, _cfg) do
    measurement = "phoenix_endpoint_stop"
    {:ok, host} = :inet.gethostname()
    tags = %{
      path: Enum.join(params.conn.path_info, "/"),
      host: host
    }
    Influx.write_point(measurement, fields, tags)
  end
end
