defmodule WippliBackendWeb.SongView do
  use WippliBackendWeb, :view
  alias WippliBackendWeb.SongView

  def render("index.json", %{songs: songs}) do
    %{data: render_many(songs, SongView, "song.json")}
  end

  def render("show.json", %{song: song}) do
    %{data: render_one(song, SongView, "song.json")}
  end

  def render("plain_song.json", %{song: song}) do
    %{id: song.id,
      title: song.title,
      #source: song.source,
      source_id: song.source_id,
      thumbnail: song.thumbnail}
  end
end
