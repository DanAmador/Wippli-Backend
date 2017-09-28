defmodule WippliBackendWeb.ParticipantController do
  use WippliBackendWeb, :controller

  alias WippliBackend.Wippli
  alias WippliBackend.Wippli.Zone
  alias WippliBackendWeb.ParticipantView
  alias WippliBackend.Wippli.Participant

  action_fallback WippliBackendWeb.FallbackController

  def create(conn, %{"zone_id" => zone_id, "user_id" => user_id} = params) do
    with {:ok, %Participant{} = participant} <- Wippli.join_zone(zone_id,user_id, params["password"]) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", zone_path(conn, :show, participant))
      |> render(ParticipantView, "created.json", %{zone_id: zone_id, user_id: user_id})
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
