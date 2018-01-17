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

  @name :FakeCasServer

  @doc "The only username `FakeCas` server will consider valid"
  @spec valid_username :: String.t
  def valid_username, do: "example"

  @doc "The only password `FakeCas` server will consider valid"
  @spec valid_password :: String.t
  def valid_password, do: "secret"

  @doc "The only TGT `FakeCas` server will consider valid"
  @spec valid_tgt :: String.t
  def valid_tgt, do: "TGT-example-abcd"

  @doc "The only ST `FakeCas` server will consider valid"
  @spec valid_st :: String.t
  def valid_st, do: "ST-example-1234"

  @doc false
  def start do
    start_link()
  end

  @doc false
  def start_link do
    start_link(name: @name)
  end

  defmacro children(opts) do
    if System.version |> Version.parse! |> Version.match?(">= 1.5.0") do
      quote do
        [{FakeCas.Server, unquote(opts)}]
      end
    else
      quote do
        import Supervisor.Spec, warn: false
        [worker(FakeCas.Server, unquote([opts]))]
      end
    end
  end

  @doc false
  def start_link(opts) do
    add_name = fn
      (opts, nil) -> opts
      (opts, name) -> Keyword.merge(opts, name: Module.concat(name, Supervisor))
    end

    Supervisor.start_link(children(opts),
      add_name.([strategy: :one_for_one], opts[:name]))
  end

  @doc "Returns the TCP port FakeCas is running on"
  @spec port() :: non_neg_integer()
  def port, do: FakeCas.Server.port(@name)

  @doc "Stops the server"
  @spec stop() :: none()
  def stop do
    Supervisor.stop(Module.concat(@name, Supervisor))
  end
end
