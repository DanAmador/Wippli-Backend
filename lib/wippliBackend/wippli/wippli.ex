defmodule WippliBackend.Wippli do
  @moduledoc """
  The Wippli context.
  """

  import Ecto.Query, warn: false
  alias WippliBackend.Repo

  alias WippliBackend.Wippli.Participants
  def create_participant(zone, user) do
    attrs = %{zone: zone, user: user}
    %Participants{} |> Participants.changeset(attrs) |> Repo.insert!
  end

  def get_participant_in_zone(zone_id) do
    Repo.get!(Zone, zone_id)
    |> Repo.preload(:participants)
  end
  alias WippliBackend.Wippli.Song
  @doc """
  Returns the list of songs.

  ## Examples

      iex> list_songs()
      [%Song{}, ...]

  """
  def list_songs do
    Repo.all(Song)
  end

  @doc """
  Gets a single song.

  Raises `Ecto.NoResultsError` if the Song does not exist.

  ## Examples

      iex> get_song!(123)
      %Song{}

      iex> get_song!(456)
      ** (Ecto.NoResultsError)

  """
  def get_song!(id), do: Repo.get!(Song, id)


  @doc """
  Creates a song.

  ## Examples

      iex> create_song(%{field: value})
      {:ok, %Song{}}

      iex> create_song(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_song(attrs \\ %{}) do
    %Song{}
    |> Song.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a song.

  ## Examples

      iex> update_song(song, %{field: new_value})
      {:ok, %Song{}}

      iex> update_song(song, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_song(%Song{} = song, attrs) do
    song
    |> Song.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Song.

  ## Examples

      iex> delete_song(song)
      {:ok, %Song{}}

      iex> delete_song(song)
      {:error, %Ecto.Changeset{}}

  """
  def delete_song(%Song{} = song) do
    Repo.delete(song)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking song changes.

  ## Examples

      iex> change_song(song)
      %Ecto.Changeset{source: %Song{}}

  """
  def change_song(%Song{} = song) do
    Song.changeset(song, %{})
  end

  alias WippliBackend.Wippli.Zone

  @doc """
  Returns the list of zones.

  ## Examples

      iex> list_zones()
      [%Zone{}, ...]

  """
  def list_zones do
    Repo.all(Zone) |> Repo.preload(:participants)
  end

  @doc """
  Gets a single zone.

  Raises `Ecto.NoResultsError` if the Zone does not exist.

  ## Examples

      iex> get_zone!(123)
      %Zone{}

      iex> get_zone!(456)
      ** (Ecto.NoResultsError)

  """
  def get_zone!(id) do
    Repo.get!(Zone, id) |> Repo.preload(:participants)
  end
  @doc """
  Creates a zone.

  ## Examples

      iex> create_zone(%{field: value})
      {:ok, %Zone{}}

      iex> create_zone(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_zone(attrs \\ %{},user) do
    %Zone{}
    |> Zone.changeset(attrs,user)
    |> Repo.insert()
  end

  @doc """
  Updates a zone.

  ## Examples

      iex> update_zone(zone, %{field: new_value})
      {:ok, %Zone{}}

      iex> update_zone(zone, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_zone(%Zone{} = zone, attrs, user) do
    zone
    |> Zone.changeset(attrs, user)
    |> Repo.update()
  end

  @doc """
  Deletes a Zone.

  ## Examples

      iex> delete_zone(zone)
      {:ok, %Zone{}}

      iex> delete_zone(zone)
      {:error, %Ecto.Changeset{}}

  """
  def delete_zone(%Zone{} = zone) do
    Repo.delete(zone)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking zone changes.

  ## Examples

      iex> change_zone(zone)
      %Ecto.Changeset{source: %Zone{}}

  """
  def change_zone(%Zone{} = zone) do
    Zone.changeset(zone, %{})
  end

  alias WippliBackend.Wippli.Vote

  @doc """
  Returns the list of votes.

  ## Examples

      iex> list_votes()
      [%Vote{}, ...]

  """
  def list_votes do
    Repo.all(Vote)
  end

  @doc """
  Gets a single vote.

  Raises `Ecto.NoResultsError` if the Vote does not exist.

  ## Examples

      iex> get_vote!(123)
      %Vote{}

      iex> get_vote!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vote!(id), do: Repo.get!(Vote, id)

  @doc """
  Creates a vote.

  ## Examples

      iex> create_vote(%{field: value})
      {:ok, %Vote{}}

      iex> create_vote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vote(attrs \\ %{}) do
    %Vote{}
    |> Vote.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a vote.

  ## Examples

      iex> update_vote(vote, %{field: new_value})
      {:ok, %Vote{}}

      iex> update_vote(vote, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vote(%Vote{} = vote, attrs) do
    vote
    |> Vote.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Vote.

  ## Examples

      iex> delete_vote(vote)
      {:ok, %Vote{}}

      iex> delete_vote(vote)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vote(%Vote{} = vote) do
    Repo.delete(vote)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vote changes.

  ## Examples

      iex> change_vote(vote)
      %Ecto.Changeset{source: %Vote{}}

  """
  def change_vote(%Vote{} = vote) do
    Vote.changeset(vote, %{})
  end

  alias WippliBackend.Wippli.PlaylistSong

  @doc """
  Returns the list of playlist_songs.

  ## Examples

      iex> list_playlist_songs()
      [%PlaylistSong{}, ...]

  """
  def list_playlist_songs do
    Repo.all(PlaylistSong)
  end

  @doc """
  Gets a single playlist_song.

  Raises `Ecto.NoResultsError` if the Playlist song does not exist.

  ## Examples

      iex> get_playlist_song!(123)
      %PlaylistSong{}

      iex> get_playlist_song!(456)
      ** (Ecto.NoResultsError)

  """
  def get_playlist_song!(id), do: Repo.get!(PlaylistSong, id)

  @doc """
  Creates a playlist_song.

  ## Examples

      iex> create_playlist_song(%{field: value})
      {:ok, %PlaylistSong{}}

      iex> create_playlist_song(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_playlist_song(attrs \\ %{}) do
    %PlaylistSong{}
    |> PlaylistSong.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a playlist_song.

  ## Examples

      iex> update_playlist_song(playlist_song, %{field: new_value})
      {:ok, %PlaylistSong{}}

      iex> update_playlist_song(playlist_song, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_playlist_song(%PlaylistSong{} = playlist_song, attrs) do
    playlist_song
    |> PlaylistSong.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PlaylistSong.

  ## Examples

      iex> delete_playlist_song(playlist_song)
      {:ok, %PlaylistSong{}}

      iex> delete_playlist_song(playlist_song)
      {:error, %Ecto.Changeset{}}

  """
  def delete_playlist_song(%PlaylistSong{} = playlist_song) do
    Repo.delete(playlist_song)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking playlist_song changes.

  ## Examples

      iex> change_playlist_song(playlist_song)
      %Ecto.Changeset{source: %PlaylistSong{}}

  """
  def change_playlist_song(%PlaylistSong{} = playlist_song) do
    PlaylistSong.changeset(playlist_song, %{})
  end

  alias WippliBackend.Wippli.Participant

  @doc """
  Returns the list of participants.

  ## Examples

      iex> list_participants()
      [%Participant{}, ...]

  """
  def list_participants do
    Repo.all(Participant)
  end

  @doc """
  Gets a single participant.

  Raises `Ecto.NoResultsError` if the Participant does not exist.

  ## Examples

      iex> get_participant!(123)
      %Participant{}

      iex> get_participant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_participant!(id), do: Repo.get!(Participant, id)

  @doc """
  Creates a participant.

  ## Examples

      iex> create_participant(%{field: value})
      {:ok, %Participant{}}

      iex> create_participant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_participant(attrs \\ %{}) do
    %Participant{}
    |> Participant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a participant.

  ## Examples

      iex> update_participant(participant, %{field: new_value})
      {:ok, %Participant{}}

      iex> update_participant(participant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_participant(%Participant{} = participant, attrs) do
    participant
    |> Participant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Participant.

  ## Examples

      iex> delete_participant(participant)
      {:ok, %Participant{}}

      iex> delete_participant(participant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_participant(%Participant{} = participant) do
    Repo.delete(participant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking participant changes.

  ## Examples

      iex> change_participant(participant)
      %Ecto.Changeset{source: %Participant{}}

  """
  def change_participant(%Participant{} = participant) do
    Participant.changeset(participant, %{})
  end
end
