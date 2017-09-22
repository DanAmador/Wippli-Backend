defmodule WippliBackendWeb.ZoneController do
  use WippliBackendWeb, :controller

  alias WippliBackend.Wippli
  alias WippliBackend.Wippli.Zone
  alias WippliBackend.Accounts
  action_fallback WippliBackendWeb.FallbackController

  def index(conn, _params) do
    zones = Wippli.list_zones()
    render(conn, "index.json", zones: zones)
  end

  def create(conn, %{"zone" => zone_params, "user_id" => user_id}) do
    user = Accounts.get_user!(user_id)
    with {:ok, %Zone{} = zone} <- Wippli.create_zone(zone_params,user) do
      Wippli.create_participant(zone,user)
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

  def delete(conn, %{"id" => id }) do
    zone = Wippli.get_zone!(id)
    with {:ok, %Zone{}} <- Wippli.delete_zone(zone) do
      send_resp(conn, :no_content, "")
    end
  end
end
