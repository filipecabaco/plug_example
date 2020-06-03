defmodule PlugExample do
  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: PlugExample.Router, options: [port: 4001]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end
end

defmodule PlugExample.Router do
  use Plug.Router

  plug(Plug.Logger)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(Ueberauth)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 202, "hello world")
  end

  get "/auth/github/callback" do
    %{assigns: %{ueberauth_auth: %{info: %{nickname: nickname}}}} = conn
    send_resp(conn, 200, "Welcome #{nickname}")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
