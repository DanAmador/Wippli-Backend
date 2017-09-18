defmodule WippliBackendWeb.SongController do
  use WippliBackendWeb, :controller

  alias WippliBackend.Wippli
  alias WippliBackend.Wippli.Song

  action_fallback WippliBackendWeb.FallbackController

  def index(conn, _params) do
    songs = Wippli.list_songs()
    render(conn, "index.json", songs: songs)
  end

  def create(conn, %{"song" => song_params}) do
    with {:ok, %Song{} = song} <- Wippli.create_song(song_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", song_path(conn, :show, song))
      |> render("show.json", song: song)
    end
  end

  def show(conn, %{"id" => id}) do
    song = Wippli.get_song!(id)
    render(conn, "show.json", song: song)
  end

  def update(conn, %{"id" => id, "song" => song_params}) do
    song = Wippli.get_song!(id)

    with {:ok, %Song{} = song} <- Wippli.update_song(song, song_params) do
      render(conn, "show.json", song: song)
    end
  end

  def delete(conn, %{"id" => id}) do
    song = Wippli.get_song!(id)
    with {:ok, %Song{}} <- Wippli.delete_song(song) do
      send_resp(conn, :no_content, "")
    end
  end
end
