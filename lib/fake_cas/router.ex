defmodule FakeCas.Router do
  @moduledoc "Application router for the `FakeCas` server"

  use Plug.Router

  require Logger

  plug(Plug.Logger)
  plug(:fetch_query_params)

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison
  )

  plug(:match)
  plug(:dispatch)

  @doc false
  def init(options), do: options

  match "/" do
    send_resp(conn, 200, "received #{inspect(conn.params)}")
  end

  post "/v1/tickets/#{FakeCas.valid_tgt()}" do
    if !is_nil(conn.params["service"]) do
      conn |> send_resp(200, FakeCas.valid_st())
    else
      conn |> send_resp(404, "ticket not found")
    end
  end

  post "/v1/tickets/:_tgt" do
    conn |> send_resp(404, "ticket not found")
  end

  post "/v1/tickets" do
    if {conn.params["username"], conn.params["password"]} ==
         {FakeCas.valid_username(), FakeCas.valid_password()} do
      conn
      |> put_resp_header("location", "#{url(conn)}/#{FakeCas.valid_tgt()}")
      |> send_resp(201, FakeCas.valid_tgt())
    else
      conn
      |> send_resp(400, "bad credentials")
    end
  end

  get "/serviceValidate" do
    if conn.params["ticket"] == FakeCas.valid_st() && conn.params["service"] do
      conn |> send_resp(200, FakeCas.Responses.success())
    else
      conn |> send_resp(200, FakeCas.Responses.failure())
    end
  end

  post "/serviceValidate" do
    if conn.params["ticket"] == FakeCas.valid_st() && conn.params["service"] do
      conn |> send_resp(200, FakeCas.Responses.success())
    else
      conn |> send_resp(200, FakeCas.Responses.failure())
    end
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

  @doc false
  @spec url(Plug.Conn.t()) :: Plug.Conn.t()
  def url(conn) do
    query_string =
      conn.query_params
      |> URI.encode_query()

    ["#{conn.scheme}://#{conn.host}:#{conn.port}#{conn.request_path}", query_string]
    |> Enum.reject(fn v -> is_nil(v) || v == "" end)
    |> Enum.join("?")
  end
end
