# defmodule FeedexCore.Metrics.InspectHandler do
#
#   def setup do
#     events = [
#       [:vm, :memory],
#       [:vm, :total_run_queue_lengths],
#       [:feedex_core, :repo, :query],
#       [:phoenix, :endpoint, :stop]
#     ]
#
#     :telemetry.attach_many(
#       "inspect-reporter",
#       events,
#       &handle_event/4,
#       nil
#     )
#   end
#   
#   def handle_event([:vm, :memory], measurements, metadata, _cfg) do
#     IO.inspect "+++++++++++++++++++++++++++++++++++++++"
#     IO.inspect measurements
#     IO.inspect metadata
#     IO.inspect "+++++++++++++++++++++++++++++++++++++++"
#   end
#
#   def handle_event([:vm, :total_run_queue_lengths], measurements, metadata, _cfg) do
#     IO.inspect "======================================="
#     IO.inspect measurements
#     IO.inspect metadata
#     IO.inspect "======================================="
#   end
#
#   def handle_event([:feedex_core, :repo, :query], _measurements, _metadata, _cfg) do
#     # IO.inspect "+++++++++++++++++++++++++++++++++++++++"
#     # IO.inspect measurements
#     # IO.inspect metadata
#     # IO.inspect "+++++++++++++++++++++++++++++++++++++++"
#   end
#
#   def handle_event([:phoenix, :endpoint, :stop], _measurements, _metadata, _cfg) do
#     # IO.inspect "======================================="
#     # IO.inspect measurements
#     # IO.inspect metadata
#     # IO.inspect "======================================="
#   end
# end
