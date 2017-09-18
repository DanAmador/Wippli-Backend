defmodule WippliBackendWeb.ZoneController do
  use WippliBackendWeb, :controller

  alias WippliBackend.Wippli
  alias WippliBackend.Wippli.Zone

  action_fallback WippliBackendWeb.FallbackController

  def index(conn, _params) do
    zones = Wippli.list_zones()
    render(conn, "index.json", zones: zones)
  end

  def create(conn, %{"zone" => zone_params}) do
    with {:ok, %Zone{} = zone} <- Wippli.create_zone(zone_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", zone_path(conn, :show, zone))
      |> render("show.json", zone: zone)
    end
  end

  def show(conn, %{"id" => id}) do
    zone = Wippli.get_zone!(id)
    render(conn, "show.json", zone: zone)
  end

  def update(conn, %{"id" => id, "zone" => zone_params}) do
    zone = Wippli.get_zone!(id)

    with {:ok, %Zone{} = zone} <- Wippli.update_zone(zone, zone_params) do
      render(conn, "show.json", zone: zone)
    end
  end

  def delete(conn, %{"id" => id}) do
    zone = Wippli.get_zone!(id)
    with {:ok, %Zone{}} <- Wippli.delete_zone(zone) do
      send_resp(conn, :no_content, "")
    end
  end
end
