defmodule WippliBackendWeb.ParticipantController do
  use WippliBackendWeb, :controller

  alias WippliBackend.Wippli
  alias WippliBackend.Accounts
  alias WippliBackend.Wippli.Zone
  alias WippliBackendWeb.ErrorView
  alias WippliBackendWeb.ParticipantView
  alias WippliBackend.Wippli.Participant

  action_fallback WippliBackendWeb.FallbackController

  def create(conn, %{"zone_id" => zone_id, "user_id" => user_id} = params) do
    user = Accounts.get_user!(user_id)
    zone = Wippli.get_zone!(zone_id)
    if zone.password == params["password"] do
      with {:ok, %Participant{} = _} <- Wippli.create_participant(zone,user) do
      conn
      |> put_status(:created)
     # |> put_resp_header("location", zone_path(conn, :show, zone))
      |> render(ParticipantView, "created.json", %{zone_id: zone.id, user_id: user.id})
      end
    else
      conn
      |> put_status(:bad_request)
      |> render(ErrorView, "400.json", message: "Incorrect password")

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
