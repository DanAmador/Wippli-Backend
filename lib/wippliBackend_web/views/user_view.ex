defmodule WippliBackendWeb.UserView do
  use WippliBackendWeb, :view
  alias WippliBackendWeb.UserView
  alias WippliBackendWeb.ZoneView
  alias WippliBackendWeb.ParticipantView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("plain_user.json", %{user: user}) do
    %{id: user.id,
      nickname: user.nickname,
      phone: user.phone,
      telegram_id: user.telegram_id
    }
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      nickname: user.nickname,
      phone: user.phone,
      telegram_id: user.telegram_id,
      created_zones: render_many(user.zones, ZoneView, "plain_zone.json"),
      participates_in: render_one(user.participants, ParticipantView, "zone_in_user.json", as: :participants),
  }
  end
end
