defmodule FeedexUi.Telemetry do

  @moduledoc """
  Telemetry for Feedex applications.
  """

  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      # {:telemetry_poller, measurements: periodic_measurements(), period: 60_000},
      # {Telemetry.Metrics.ConsoleReporter, metrics: metrics()}
      # {TelemetryInfluxDB, [
      #   events: [
      #     %{name: [:feedex_core, :post_count]},
      #     %{name: [:phoenix, :endpoint, :stop, :duration]},
      #     %{name: [:vm, :memory, :total]}
      #   ],
      #   protocol: :http,
      #   host: "localhost",
      #   port: 8086,
      #   db: "inf_feedex_dev",
      #   username: "admin", 
      #   password: "admin"
      #   ]
      # }
    ]

    current_env = Application.get_env(:feedex_core, :environment)
    if current_env != :test do
      FeedexMetrics.Handlers.InspectHandler.setup()
      # FeedexCore.Metrics.InfluxHandler.setup()
    end

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      # Phoenix Metrics
      # summary([:phoenix, :endpoint, :stop, :duration],
      #   unit: {:native, :millisecond}
      # ),
      # summary("phoenix.endpoint.stop.duration",
      #   unit: {:native, :millisecond}
      # ),
      # summary("phoenix.router_dispatch.stop.duration",
      #   tags: [:route],
      #   unit: {:native, :millisecond}
      # ),

      # Database Metrics
      # summary("feedex_core.repo.query.total_time", unit: {:native, :millisecond}),
      counter("feedex_core.repo.query.total_time"),
      # summary("feedex_ui.repo.query.decode_time", unit: {:native, :millisecond}),
      # summary("feedex_core.repo.query.query_time", unit: {:native, :millisecond}),
      # summary("feedex_core.repo.init"),
      # summary("feedex_core.ecto.repo.init"),
      # summary("ecto.repo.init"),
      # summary([:ecto, :repo, :init]),
      last_value([:ecto, :repo, :init]),
      # summary("feedex_ui.repo.query.queue_time", unit: {:native, :millisecond}),
      # summary("feedex_ui.repo.query.idle_time", unit: {:native, :millisecond}),

      # VM Metrics
      # summary("vm.memory.total", unit: {:byte, :kilobyte}),
      # summary("vm.total_run_queue_lengths.total"),
      # summary("vm.total_run_queue_lengths.cpu"),
      # summary("vm.total_run_queue_lengths.io"),

      # Periodic Metrics
      # summary("feedex_core.post_count")
    ]
  end

  defp periodic_measurements do
    [
      # A module, function and arguments to be invoked periodically.
      # This function must call :telemetry.execute/3 and a metric must be added above.
      # {FeedexUi, :count_users, []}
      # {FeedexCore.Metrics.Periodic, :post_counts, []}
    ]
  end
end
