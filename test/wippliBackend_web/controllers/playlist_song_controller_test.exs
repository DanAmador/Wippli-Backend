defmodule WippliBackendWeb.PlaylistSongControllerTest do
  use WippliBackendWeb.ConnCase

  alias WippliBackend.Wippli
  alias WippliBackend.Wippli.PlaylistSong

  @create_attrs %{rating: 42}
  @update_attrs %{rating: 43}
  @invalid_attrs %{rating: nil}

  def fixture(:playlist_song) do
    {:ok, playlist_song} = Wippli.create_playlist_song(@create_attrs)
    playlist_song
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all playlist_songs", %{conn: conn} do
      conn = get conn, playlist_song_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create playlist_song" do
    test "renders playlist_song when data is valid", %{conn: conn} do
      conn = post conn, playlist_song_path(conn, :create), playlist_song: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, playlist_song_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "rating" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, playlist_song_path(conn, :create), playlist_song: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update playlist_song" do
    setup [:create_playlist_song]

    test "renders playlist_song when data is valid", %{conn: conn, playlist_song: %PlaylistSong{id: id} = playlist_song} do
      conn = put conn, playlist_song_path(conn, :update, playlist_song), playlist_song: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, playlist_song_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "rating" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, playlist_song: playlist_song} do
      conn = put conn, playlist_song_path(conn, :update, playlist_song), playlist_song: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete playlist_song" do
    setup [:create_playlist_song]

    test "deletes chosen playlist_song", %{conn: conn, playlist_song: playlist_song} do
      conn = delete conn, playlist_song_path(conn, :delete, playlist_song)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, playlist_song_path(conn, :show, playlist_song)
      end
    end
  end

  defp create_playlist_song(_) do
    playlist_song = fixture(:playlist_song)
    {:ok, playlist_song: playlist_song}
  end
end
