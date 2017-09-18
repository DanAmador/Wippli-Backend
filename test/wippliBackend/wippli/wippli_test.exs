defmodule WippliBackend.WippliTest do
  use WippliBackend.DataCase

  alias WippliBackend.Wippli

  describe "songs" do
    alias WippliBackend.Wippli.Song

    @valid_attrs %{source: 42, source_id: "some source_id", thumbnail: "some thumbnail", title: "some title"}
    @update_attrs %{source: 43, source_id: "some updated source_id", thumbnail: "some updated thumbnail", title: "some updated title"}
    @invalid_attrs %{source: nil, source_id: nil, thumbnail: nil, title: nil}

    def song_fixture(attrs \\ %{}) do
      {:ok, song} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Wippli.create_song()

      song
    end

    test "list_songs/0 returns all songs" do
      song = song_fixture()
      assert Wippli.list_songs() == [song]
    end

    test "get_song!/1 returns the song with given id" do
      song = song_fixture()
      assert Wippli.get_song!(song.id) == song
    end

    test "create_song/1 with valid data creates a song" do
      assert {:ok, %Song{} = song} = Wippli.create_song(@valid_attrs)
      assert song.source == 42
      assert song.source_id == "some source_id"
      assert song.thumbnail == "some thumbnail"
      assert song.title == "some title"
    end

    test "create_song/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wippli.create_song(@invalid_attrs)
    end

    test "update_song/2 with valid data updates the song" do
      song = song_fixture()
      assert {:ok, song} = Wippli.update_song(song, @update_attrs)
      assert %Song{} = song
      assert song.source == 43
      assert song.source_id == "some updated source_id"
      assert song.thumbnail == "some updated thumbnail"
      assert song.title == "some updated title"
    end

    test "update_song/2 with invalid data returns error changeset" do
      song = song_fixture()
      assert {:error, %Ecto.Changeset{}} = Wippli.update_song(song, @invalid_attrs)
      assert song == Wippli.get_song!(song.id)
    end

    test "delete_song/1 deletes the song" do
      song = song_fixture()
      assert {:ok, %Song{}} = Wippli.delete_song(song)
      assert_raise Ecto.NoResultsError, fn -> Wippli.get_song!(song.id) end
    end

    test "change_song/1 returns a song changeset" do
      song = song_fixture()
      assert %Ecto.Changeset{} = Wippli.change_song(song)
    end
  end

  describe "zones" do
    alias WippliBackend.Wippli.Zone

    @valid_attrs %{password: "some password"}
    @update_attrs %{password: "some updated password"}
    @invalid_attrs %{password: nil}

    def zone_fixture(attrs \\ %{}) do
      {:ok, zone} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Wippli.create_zone()

      zone
    end

    test "list_zones/0 returns all zones" do
      zone = zone_fixture()
      assert Wippli.list_zones() == [zone]
    end

    test "get_zone!/1 returns the zone with given id" do
      zone = zone_fixture()
      assert Wippli.get_zone!(zone.id) == zone
    end

    test "create_zone/1 with valid data creates a zone" do
      assert {:ok, %Zone{} = zone} = Wippli.create_zone(@valid_attrs)
      assert zone.password == "some password"
    end

    test "create_zone/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wippli.create_zone(@invalid_attrs)
    end

    test "update_zone/2 with valid data updates the zone" do
      zone = zone_fixture()
      assert {:ok, zone} = Wippli.update_zone(zone, @update_attrs)
      assert %Zone{} = zone
      assert zone.password == "some updated password"
    end

    test "update_zone/2 with invalid data returns error changeset" do
      zone = zone_fixture()
      assert {:error, %Ecto.Changeset{}} = Wippli.update_zone(zone, @invalid_attrs)
      assert zone == Wippli.get_zone!(zone.id)
    end

    test "delete_zone/1 deletes the zone" do
      zone = zone_fixture()
      assert {:ok, %Zone{}} = Wippli.delete_zone(zone)
      assert_raise Ecto.NoResultsError, fn -> Wippli.get_zone!(zone.id) end
    end

    test "change_zone/1 returns a zone changeset" do
      zone = zone_fixture()
      assert %Ecto.Changeset{} = Wippli.change_zone(zone)
    end
  end

  describe "votes" do
    alias WippliBackend.Wippli.Vote

    @valid_attrs %{rating: 42}
    @update_attrs %{rating: 43}
    @invalid_attrs %{rating: nil}

    def vote_fixture(attrs \\ %{}) do
      {:ok, vote} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Wippli.create_vote()

      vote
    end

    test "list_votes/0 returns all votes" do
      vote = vote_fixture()
      assert Wippli.list_votes() == [vote]
    end

    test "get_vote!/1 returns the vote with given id" do
      vote = vote_fixture()
      assert Wippli.get_vote!(vote.id) == vote
    end

    test "create_vote/1 with valid data creates a vote" do
      assert {:ok, %Vote{} = vote} = Wippli.create_vote(@valid_attrs)
      assert vote.rating == 42
    end

    test "create_vote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wippli.create_vote(@invalid_attrs)
    end

    test "update_vote/2 with valid data updates the vote" do
      vote = vote_fixture()
      assert {:ok, vote} = Wippli.update_vote(vote, @update_attrs)
      assert %Vote{} = vote
      assert vote.rating == 43
    end

    test "update_vote/2 with invalid data returns error changeset" do
      vote = vote_fixture()
      assert {:error, %Ecto.Changeset{}} = Wippli.update_vote(vote, @invalid_attrs)
      assert vote == Wippli.get_vote!(vote.id)
    end

    test "delete_vote/1 deletes the vote" do
      vote = vote_fixture()
      assert {:ok, %Vote{}} = Wippli.delete_vote(vote)
      assert_raise Ecto.NoResultsError, fn -> Wippli.get_vote!(vote.id) end
    end

    test "change_vote/1 returns a vote changeset" do
      vote = vote_fixture()
      assert %Ecto.Changeset{} = Wippli.change_vote(vote)
    end
  end

  describe "playlist_songs" do
    alias WippliBackend.Wippli.PlaylistSong

    @valid_attrs %{rating: 42}
    @update_attrs %{rating: 43}
    @invalid_attrs %{rating: nil}

    def playlist_song_fixture(attrs \\ %{}) do
      {:ok, playlist_song} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Wippli.create_playlist_song()

      playlist_song
    end

    test "list_playlist_songs/0 returns all playlist_songs" do
      playlist_song = playlist_song_fixture()
      assert Wippli.list_playlist_songs() == [playlist_song]
    end

    test "get_playlist_song!/1 returns the playlist_song with given id" do
      playlist_song = playlist_song_fixture()
      assert Wippli.get_playlist_song!(playlist_song.id) == playlist_song
    end

    test "create_playlist_song/1 with valid data creates a playlist_song" do
      assert {:ok, %PlaylistSong{} = playlist_song} = Wippli.create_playlist_song(@valid_attrs)
      assert playlist_song.rating == 42
    end

    test "create_playlist_song/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wippli.create_playlist_song(@invalid_attrs)
    end

    test "update_playlist_song/2 with valid data updates the playlist_song" do
      playlist_song = playlist_song_fixture()
      assert {:ok, playlist_song} = Wippli.update_playlist_song(playlist_song, @update_attrs)
      assert %PlaylistSong{} = playlist_song
      assert playlist_song.rating == 43
    end

    test "update_playlist_song/2 with invalid data returns error changeset" do
      playlist_song = playlist_song_fixture()
      assert {:error, %Ecto.Changeset{}} = Wippli.update_playlist_song(playlist_song, @invalid_attrs)
      assert playlist_song == Wippli.get_playlist_song!(playlist_song.id)
    end

    test "delete_playlist_song/1 deletes the playlist_song" do
      playlist_song = playlist_song_fixture()
      assert {:ok, %PlaylistSong{}} = Wippli.delete_playlist_song(playlist_song)
      assert_raise Ecto.NoResultsError, fn -> Wippli.get_playlist_song!(playlist_song.id) end
    end

    test "change_playlist_song/1 returns a playlist_song changeset" do
      playlist_song = playlist_song_fixture()
      assert %Ecto.Changeset{} = Wippli.change_playlist_song(playlist_song)
    end
  end
end
