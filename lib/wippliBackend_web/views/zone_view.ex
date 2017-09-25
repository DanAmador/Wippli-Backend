defmodule WippliBackendWeb.ZoneView do
  use WippliBackendWeb, :view
  alias WippliBackendWeb.ZoneView
  alias WippliBackendWeb.ParticipantView
  def render("index.json", %{zones: zones}) do
    render_many(zones, ZoneView, "zone_with_participants.json")
  end

  def render("show.json", %{zone: zone}) do
    render_one(zone, ZoneView, "plain_zone.json")
  end


  def render("zone_with_participants.json", %{zone: zone }) do
    %{id: zone.id,
      password: zone.password,
      participants: render_many(zone.participants, ParticipantView, "users_in_zone.json", as: :participants),
      updated_at: zone.updated_at}
  end

  def render("plain_zone.json", %{zone: zone}) do
    %{id: zone.id,
      password: zone.password,
      created_at: zone.inserted_at}
  end
end
