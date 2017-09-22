defmodule WippliBackendWeb.ParticipantView do
  use WippliBackendWeb, :view
  alias WippliBackendWeb.ParticipantView

  def render("index.json",%{participants: participants}) do
    %{data: render_many(participants, ParticipantsView, "participants.json")}
  end

  def render("show.json", %{participants: participants}) do
    %{data: render_one(participants, ParticipantsView, "participants.json")}
  end

  def render("zones_in_user.json", %{participants: participants}) do
    %{
      in_zone: participants.zone_id,
      updated_at: participants.updated_at
    }
  end

  def render("participants_in_zone.json", %{participants: participants}) do
    %{
      user_id: participants.user_id,
      updated_at: participants.updated_at
    }
  end
end
