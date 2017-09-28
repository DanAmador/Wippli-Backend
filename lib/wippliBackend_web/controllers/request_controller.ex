defmodule WippliBackendWeb.RequestController do
  use WippliBackendWeb, :controller

  alias WippliBackend.Wippli
  alias WippliBackend.Wippli.Request

  action_fallback WippliBackendWeb.FallbackController

  def index(conn, _params) do
    requests = Wippli.list_requests()
    render(conn, "index.json", requests: requests)
  end

  def create(conn, %{"request" => request_params}) do
    with {:ok, %Request{} = request} <- Wippli.create_request(request_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", request_path(conn, :show, request))
      |> render("show.json", request: request)
    end
  end

  def show(conn, %{"id" => id}) do
    request = Wippli.get_request!(id)
    render(conn, "show.json", request: request)
  end

  def update(conn, %{"id" => id, "request" => request_params}) do
    request = Wippli.get_request!(id)

    with {:ok, %Request{} = request} <- Wippli.update_request(request, request_params) do
      render(conn, "show.json", request: request)
    end
  end

  def delete(conn, %{"id" => id}) do
    request = Wippli.get_request!(id)
    with {:ok, %Request{}} <- Wippli.delete_request(request) do
      send_resp(conn, :no_content, "")
    end
  end
end
