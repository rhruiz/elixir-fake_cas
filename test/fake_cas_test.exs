defmodule FakeCasTest do
  use ExUnit.Case, async: true

  test "it stars a server" do
    {:ok, pid} = FakeCas.start()
    assert is_pid(pid)
  end

  test "port/0 returns the port the server is running" do
    FakeCas.start()

    port = FakeCas.port()
    assert port >= 1024
    assert port <= 65535
  end
end
