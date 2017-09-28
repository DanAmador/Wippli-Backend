defmodule WippliBackendWeb.ZoneController do
  use WippliBackendWeb, :controller

  alias WippliBackend.Wippli
  alias WippliBackend.Wippli.Zone
  action_fallback WippliBackendWeb.FallbackController

  def index(conn, _params) do
    zones = Wippli.list_zones()
    render(conn, "index.json", zones: zones)
  end

  def create(conn, %{"zone" => zone_params, "user_id" => user_id}) do
    with {:ok, %Zone{} = zone} <- Wippli.create_zone(zone_params, user_id) do
      Wippli.create_participant(zone.id,user_id)
      conn
      |> put_status(:created)
      |> put_resp_header("location", zone_path(conn, :show, zone))
      |> render("show.json", zone: zone)
    end
  end

  def show(conn, %{"id" => id}) do
    zone = Wippli.get_zone!(id)
    render(conn, "zone_with_participants.json", zone: zone)
  end

  def update(conn, %{"id" => id, "old_password" => old_password, "user_id" => user_id, "new_password" => new_password}) do
    zone = Wippli.get_zone!(id)
    with {:ok, %Zone{} = zone} <- Wippli.update_zone(zone, %{password: new_password, old_password: old_password, user_id: user_id}) do
      render(conn, "plain_zone.json", zone: zone)
    end
  end

  def delete(conn, %{"id" => id }) do
    zone = Wippli.get_zone!(id)
    with {:ok, %Zone{}} <- Wippli.delete_zone(zone) do
      send_resp(conn, :no_content, "")
    end
  end
end
