defmodule FakeCasTest do
  use ExUnit.Case, async: false

  test "it stars a server" do
    {:ok, pid} = FakeCas.start_link()
    assert is_pid(pid)

    FakeCas.stop()
  end

  test "port/0 returns the port the server is running" do
    case FakeCas.start_link() do
      {:ok, _pid} -> :ok
      {:error, {:already_started, _pid}} -> :ok
    end

    port = FakeCas.port()

    assert port >= 1024
    assert port <= 65535

    FakeCas.stop()
  end
end
