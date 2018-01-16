defmodule FakeCas.ServerTest do
  use ExUnit.Case, async: true

  setup do
    length = 32
    name =  :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
    {:ok, pid} = FakeCas.Server.start_link(name: :"#{name}")
    {:ok, pid: pid}
  end

  test "port/0 returns the port the server is running", %{pid: pid} do
    port = FakeCas.Server.port(pid)

    assert port >= 1024
    assert port <= 65535
  end

  test "a get on the port is successful", %{pid: pid} do
    port = FakeCas.Server.port(pid)
    url = "http://localhost:#{port}/"

    assert {:ok, %HTTPoison.Response{status_code: 200}} = HTTPoison.get(url)
  end
end
