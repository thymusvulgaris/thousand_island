defmodule ThousandIsland.ConnectionWorker do
  use Task

  require Logger

  alias ThousandIsland.Connection

  def start_link(args) do
    Task.start_link(__MODULE__, :run, [args])
  end

  def run({socket, transport_module, handler_module, handler_opts}) do
    conn = Connection.new(socket, transport_module)

    try do
      Logger.debug("Connection #{inspect(self())} starting up")

      handler_module.handle_connection(conn, handler_opts)

      Logger.debug("Connection #{inspect(self())} shutting down")
    after
      Connection.close(conn)
    end
  end
end
