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
      zone: participants.zone_id,
      joined_at: participants.updated_at
    }
  end

  def render("participants.json", %{participants: participants}) do
    %{
      user: participants.user_id,
      zone: participants.zone_id,
      joined_at: participants.updated_at
    }
  end


  def render("created.json", %{user_id: user_id, zone_id: zone_id}) do
    
    %{
      user_id: user_id,
      zone_id: zone_id
    }
  end
    def render("users_in_zone.json", %{participants: participants}) do
    %{
      user_id: participants.user_id,
      joined_at: participants.updated_at
    }
  end
end
