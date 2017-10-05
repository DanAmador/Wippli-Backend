defmodule WippliBackendWeb.RequestView do
  use WippliBackendWeb, :view
  alias WippliBackendWeb.RequestView
  alias WippliBackendWeb.SongView

  def render("index.json", %{requests: requests}) do
    %{data: render_many(requests, RequestView, "request.json")}
  end

  def render("show.json", %{request: request}) do
    render_one(request, RequestView, "request.json")
  end

  def render("request.json", %{request: request}) do
    %{
      id: request.id,
      song: render_one(request.song, SongView, "plain_song.json")
    }
  end
end
