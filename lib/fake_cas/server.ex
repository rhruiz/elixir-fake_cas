defmodule FakeCas.Server do
  @moduledoc "GenServer used to start a CAS mock"

  use GenServer

  @doc false
  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  @doc false
  def init(:ok) do
    {:ok, s} = :ranch_tcp.listen(port: 0)
    {:ok, port} = :inet.port(s)
    :erlang.port_close(s)
    {:ok, socket} = :ranch_tcp.listen(port: port)

    ref = make_ref

    cowboy_opts = [ref: ref, acceptors: 5, port: port, socket: socket]
    {:ok, cowboy_pid} = Plug.Adapters.Cowboy.http(FakeCas.Router, [], cowboy_opts)
    {:ok, [cowboy_pid: cowboy_pid, port: port]}
  end

  @doc false
  def port(pid) do
    GenServer.call(pid, {:port})
  end

  @doc false
  def handle_call({:port}, _from, state) do
    {:reply, state[:port], state}
  end
end
