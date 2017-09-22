defmodule WippliBackendWeb.ZoneView do
  use WippliBackendWeb, :view
  alias WippliBackendWeb.ZoneView

  def render("index.json", %{zones: zones}) do
    %{data: render_many(zones, ZoneView, "zone.json")}
  end

  def render("show.json", %{zone: zone}) do
    %{data: render_one(zone, ZoneView, "zone.json")}
  end

  def render("zone.json", %{zone: zone}) do
    %{id: zone.id,
      password: zone.password,
      created_at: zone.inserted_at}
  end
end
