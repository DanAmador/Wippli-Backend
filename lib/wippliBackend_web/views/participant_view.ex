defmodule WippliBackendWeb.ParticipantView do
  use WippliBackendWeb, :view
  alias WippliBackendWeb.ParticipantView

  def render("index.json",%{participants: participants}) do
    %{data: render_many(participants, ParticipantView, "participants.json")}
  end

  def render("show.json", %{participants: participants}) do
    %{data: render_one(participants, ParticipantView, "participants.json")}
  end

  def render("zones_in_user.json", %{participants: participants}) do
    %{
      in_zone: render_one(participants.zone_id, ZoneView, "plain_zone.json"),
      updated_at: participants.updated_at
    }
  end


  def render("users_in_zone.json", %{participants: participants}) do
    %{
      shit: "fuck",
      # user: render_one(participants.user, UserView, "plain_user.json"),
      updated_at: participants.updated_at
    }
  end
  def render("test.json", %{participants: participants}) do
    %{
      shit: "fuck"
    }
  end

end
