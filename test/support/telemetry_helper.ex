defmodule TelemetryHelper do
  @moduledoc false

  def attach_many(events) do
    :telemetry.attach_many(
      "#{inspect(self())}.trace",
      events,
      &__MODULE__.record_event/4,
      self()
    )
  end

  def attach(event) do
    :telemetry.attach(
      "#{inspect(self())}.trace",
      event,
      &__MODULE__.record_event/4,
      self()
    )
  end

  def record_event(event, measurements, metadata, pid) do
    send(pid, {event, measurements, metadata})
  end
end
