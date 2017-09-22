defmodule WippliBackendWeb.UserView do
  use WippliBackendWeb, :view
  alias WippliBackendWeb.UserView
  alias WippliBackendWeb.ZoneView
  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("show_without_zones.json", %{user: user}) do
    %{id: user.id,
      phone: user.phone,
      telegram_id: user.telegram_id
    }
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      phone: user.phone,
      telegram_id: user.telegram_id,
      created_zones: render_many(user.zones, ZoneView, "zone.json"),
    updated_at: user.updated_at}
  end
end
