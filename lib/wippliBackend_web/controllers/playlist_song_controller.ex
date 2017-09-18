defmodule WippliBackendWeb.PlaylistSongController do
  use WippliBackendWeb, :controller

  alias WippliBackend.Wippli
  alias WippliBackend.Wippli.PlaylistSong

  action_fallback WippliBackendWeb.FallbackController

  def index(conn, _params) do
    playlist_songs = Wippli.list_playlist_songs()
    render(conn, "index.json", playlist_songs: playlist_songs)
  end

  def create(conn, %{"playlist_song" => playlist_song_params}) do
    with {:ok, %PlaylistSong{} = playlist_song} <- Wippli.create_playlist_song(playlist_song_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", playlist_song_path(conn, :show, playlist_song))
      |> render("show.json", playlist_song: playlist_song)
    end
  end

  def show(conn, %{"id" => id}) do
    playlist_song = Wippli.get_playlist_song!(id)
    render(conn, "show.json", playlist_song: playlist_song)
  end

  def update(conn, %{"id" => id, "playlist_song" => playlist_song_params}) do
    playlist_song = Wippli.get_playlist_song!(id)

    with {:ok, %PlaylistSong{} = playlist_song} <- Wippli.update_playlist_song(playlist_song, playlist_song_params) do
      render(conn, "show.json", playlist_song: playlist_song)
    end
  end

  def delete(conn, %{"id" => id}) do
    playlist_song = Wippli.get_playlist_song!(id)
    with {:ok, %PlaylistSong{}} <- Wippli.delete_playlist_song(playlist_song) do
      send_resp(conn, :no_content, "")
    end
  end
end
