defmodule FakeCas.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias FakeCas.Router

  test "a GET / is sucessful" do
    assert %Plug.Conn{status: 200} =
             conn(:get, "/")
             |> Router.call([])
  end

  test "a POST to /v1/tickets with invalid credentials returns 400" do
    assert {"root", "charlie"} != {FakeCas.valid_username(), FakeCas.valid_password()}

    assert %Plug.Conn{status: 400} =
             conn(:post, "/v1/tickets", username: "root", password: "charlie")
             |> Router.call([])
  end

  test "a POST to /v1/tickets with valid credentials returns 201" do
    assert %Plug.Conn{status: 201} =
             conn(
               :post,
               "/v1/tickets",
               username: FakeCas.valid_username(),
               password: FakeCas.valid_password()
             )
             |> Router.call([])
  end

  test "a POST to /v1/tickets with valid credentials returns a header location with the tgt url" do
    assert ["http://www.example.com:80/v1/tickets/#{FakeCas.valid_tgt()}"] ==
             conn(
               :post,
               "/v1/tickets",
               username: FakeCas.valid_username(),
               password: FakeCas.valid_password()
             )
             |> Router.call([])
             |> Plug.Conn.get_resp_header("location")
  end

  test "a POST to /v1/tickets/${valid_tgt} with a service returns the service ticket in the body" do
    conn =
      conn(:post, "/v1/tickets/#{FakeCas.valid_tgt()}", service: "something")
      |> Router.call([])

    assert FakeCas.valid_st() == conn.resp_body
  end

  test "a POST to /v1/tickets/${valid_tgt} without a service returns 404" do
    assert %Plug.Conn{status: 404} =
             conn(:post, "/v1/tickets/#{FakeCas.valid_tgt()}")
             |> Router.call([])
  end

  test "a POST to a /v1/tickets/${invalid_tgt} returns 404" do
    assert %Plug.Conn{status: 404} =
             conn(:post, "/v1/tickets/VR", service: "something")
             |> Router.call([])
  end

  test "a POST to /serviceValidate with a valid st returns a success response" do
    conn =
      conn(:post, "/serviceValidate", ticket: FakeCas.valid_st(), service: "something")
      |> Router.call([])

    assert Regex.match?(~r/cas:authenticationSuccess/i, conn.resp_body)
  end

  test "a POST to /serviceValidate with an valid st returns an error response" do
    st = "ST-Something"
    assert st != FakeCas.valid_st()

    conn =
      conn(:post, "/serviceValidate", ticket: st, service: "something")
      |> Router.call([])

    assert Regex.match?(~r/cas:authenticationFailure/i, conn.resp_body)
  end

  test "a POST to an unkown route returns a 404" do
    assert %Plug.Conn{status: 404} =
             conn(:post, "/not-here", some: "param")
             |> Router.call([])
  end

  test "a GET to an unkown route returns a 404" do
    assert %Plug.Conn{status: 404} =
             conn(:get, "/not-here")
             |> Router.call([])
  end
end
