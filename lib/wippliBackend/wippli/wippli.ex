defmodule WippliBackend.Wippli do
  @moduledoc """
  The Wippli context.
  """

  import Ecto.Query, warn: false
  alias WippliBackend.Repo
  alias WippliBackend.Accounts

  alias WippliBackend.Wippli.Participant

  #Participants
  def create_participant(zone, user) do
    attrs = %{zone: zone, user: user}
    %Participant{}
    |> Participant.changeset(attrs)
    |> Repo.insert!
  end

  def get_participant_in_zone(zone_id) do
    Repo.get!(Zone, zone_id)
    |> Repo.preload(:participants)
  end



#Songs
  alias WippliBackend.Wippli.Song
  def list_songs do
    Repo.all(Song)
  end

 def get_song!(id), do: Repo.get!(Song, id)

  def create_song(attrs \\ %{}) do
    %Song{}
    |> Song.changeset(attrs)
    |> Repo.insert()
  end

  def update_song(%Song{} = song, attrs) do
    song
    |> Song.changeset(attrs)
    |> Repo.update()
  end

  def delete_song(%Song{} = song) do
    Repo.delete(song)
  end

  def change_song(%Song{} = song) do
    Song.changeset(song, %{})
  end



  #Zones
  alias WippliBackend.Wippli.Zone

  def list_zones do
    Repo.all(Zone) |> Repo.preload(:participants)
  end

  def get_zone!(id) do
    Repo.get!(Zone, id) |> Repo.preload(:participants)
  end


  def create_zone(attrs \\ %{}, user_id) do
    user = Accounts.get_user!(user_id)
    zone =  %Zone{}
    |> Zone.changeset(attrs,user)
    |> Repo.insert()
  end

    def update_zone(%Zone{} = zone, attrs) do
    zone
    |> Zone.update_set(attrs)
    |> Repo.update()
  end

  def delete_zone(%Zone{} = zone) do
    Repo.delete(zone)
  end

  def change_zone(%Zone{} = zone) do
    Zone.changeset(zone, %{})
  end

  alias WippliBackend.Wippli.Vote

  def list_votes do
    Repo.all(Vote)
  end



  #Votes
  def get_vote!(id), do: Repo.get!(Vote, id)


  def create_vote(attrs \\ %{}) do
    %Vote{}
    |> Vote.changeset(attrs)
    |> Repo.insert()
  end

  def update_vote(%Vote{} = vote, attrs) do
    vote
    |> Vote.changeset(attrs)
    |> Repo.update()
  end

  def delete_vote(%Vote{} = vote) do
    Repo.delete(vote)
  end

  def change_vote(%Vote{} = vote) do
    Vote.changeset(vote, %{})
  end



  #Playlist Songs
  alias WippliBackend.Wippli.PlaylistSong

  def list_playlist_songs do
    Repo.all(PlaylistSong)
  end

  def get_playlist_song!(id), do: Repo.get!(PlaylistSong, id)


  def create_playlist_song(attrs \\ %{}) do
    %PlaylistSong{}
    |> PlaylistSong.changeset(attrs)
    |> Repo.insert()
  end

  def update_playlist_song(%PlaylistSong{} = playlist_song, attrs) do
    playlist_song
    |> PlaylistSong.changeset(attrs)
    |> Repo.update()
  end

  def delete_playlist_song(%PlaylistSong{} = playlist_song) do
    Repo.delete(playlist_song)
  end

  def change_playlist_song(%PlaylistSong{} = playlist_song) do
    PlaylistSong.changeset(playlist_song, %{})
  end



  #Participants
  def list_participants do
    Repo.all(Participant)
  end

  def get_participant!(id), do: Repo.get!(Participant, id)

  def update_participant(%Participant{} = participant, attrs) do
    participant
    |> Participant.changeset(attrs)
    |> Repo.update()
  end

  def delete_participant(%Participant{} = participant) do
    Repo.delete(participant)
  end

  def change_participant(%Participant{} = participant) do
    Participant.changeset(participant, %{})
  end
end
