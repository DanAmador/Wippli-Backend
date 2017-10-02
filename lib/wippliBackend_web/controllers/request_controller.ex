defmodule WippliBackendWeb.RequestController do
  use WippliBackendWeb, :controller

  alias WippliBackend.Wippli
  alias WippliBackend.Wippli.Request

  action_fallback WippliBackendWeb.FallbackController

  def index(conn, _params) do
    requests = Wippli.list_requests()
    render(conn, "index.json", requests: requests)
  end

  def create(conn, %{"user_id" => user_id, "song_url" => song_url, "zone_id" => zone_id}) do
    with {:ok, %Request{} = request} <- Wippli.create_request(user_id, zone_id, song_url) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", request_path(conn, :create, request))
      |> render("show.json", request: request)
    end
  end

  def show(conn, %{"id" => id}) do
    request = Wippli.get_request!(id)
    render(conn, "show.json", request: request)
  end
end
