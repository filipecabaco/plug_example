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
  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 202, "hello world")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
