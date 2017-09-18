defmodule WippliBackendWeb.UserView do
  use WippliBackendWeb, :view
  alias WippliBackendWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      phone: user.phone,
      telegram_id: user.telegram_id,
      zone_id: user.zone_id,
    updated_at: user.updated_at}
  end
end
