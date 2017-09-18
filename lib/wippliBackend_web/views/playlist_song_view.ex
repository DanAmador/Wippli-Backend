defmodule WippliBackendWeb.PlaylistSongView do
  use WippliBackendWeb, :view
  alias WippliBackendWeb.PlaylistSongView

  def render("index.json", %{playlist_songs: playlist_songs}) do
    %{data: render_many(playlist_songs, PlaylistSongView, "playlist_song.json")}
  end

  def render("show.json", %{playlist_song: playlist_song}) do
    %{data: render_one(playlist_song, PlaylistSongView, "playlist_song.json")}
  end

  def render("playlist_song.json", %{playlist_song: playlist_song}) do
    %{id: playlist_song.id,
      rating: playlist_song.rating}
  end
end
