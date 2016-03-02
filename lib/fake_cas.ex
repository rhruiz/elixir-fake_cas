defmodule FakeCas do
  @moduledoc """
  This module starts an application running an webserver that stubs CAS requests.

  ## Starting

  Start the GenServer by calling `FakeCas.start`.
  The TCP port FakeCas is running can be obtained by calling `FakeCas.port`

  ## Requests

  The server will validate requests do a `POST /v1/tickets` and validate credentials against the `valid_*` functions on `FakeCas` module

  The server will always return the same TGT

  It will also generate STs using the valid TGT for any service on `POST /v1/tickets/\#{valid_tgt}`

  Trying to validate the ST in `FakeCas.valid_st/0` will always succeed for any service:
  Any other value will fail.

  """

  use Application

  @name :FakeCasServer

  @spec valid_username :: String.t
  @doc "The only username `FakeCas` server will consider valid"
  def valid_username, do: "example"

  @spec valid_password :: String.t
  @doc "The only password `FakeCas` server will consider valid"
  def valid_password, do: "secret"

  @spec valid_tgt :: String.t
  @doc "The only TGT `FakeCas` server will consider valid"
  def valid_tgt, do: "TGT-example-abcd"

  @spec valid_st :: String.t
  @doc "The only ST `FakeCas` server will consider valid"
  def valid_st, do: "ST-example-1234"

  @doc false
  def start do
    start(:a, :b)
  end

  @doc false
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(FakeCas.Server, [@name])
    ]

    opts = [strategy: :one_for_one, name: FakeCas.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc "Returns the TCP port FakeCas is running on"
  def port, do: FakeCas.Server.port(@name)
end
