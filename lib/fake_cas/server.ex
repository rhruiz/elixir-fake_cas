defmodule FakeCas.Server do
  @moduledoc "GenServer used to start a CAS mock"

  use GenServer

  @doc "Starts a FakeCas.Server registered with the given name"
  @spec start_link(String.t()) :: GenServer.on_start()
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc false
  def init(:ok) do
    ref = make_ref()

    Process.flag(:trap_exit, true)

    cowboy_opts = [ref: ref, port: 0]
    {:ok, cowboy_pid} = Plug.Cowboy.http(FakeCas.Router, [], cowboy_opts)
    port = :ranch.get_port(ref)
    {:ok, [cowboy_ref: ref, cowboy_pid: cowboy_pid, port: port]}
  end

  @doc "Stops the server running on pid"
  @spec stop(GenServer.server()) :: :ok
  def stop(pid) do
    GenServer.stop(pid, :normal)
  end

  def terminate(reason, state) when reason in [:shutdown, :normal] do
    state
    |> Keyword.get(:cowboy_ref)
    |> Plug.Cowboy.shutdown()
  end

  @doc "Returns the port the server is bound to"
  @spec port(GenServer.server()) :: non_neg_integer()
  def port(pid) do
    GenServer.call(pid, {:port})
  end

  def handle_call({:port}, _from, state) do
    {:reply, state[:port], state}
  end
end
