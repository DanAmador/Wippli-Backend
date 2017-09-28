defmodule WippliBackend.Wippli do
  @moduledoc """
  The Wippli context.
  """

  import Ecto.Query, warn: false
  alias WippliBackend.Repo
  alias WippliBackend.Accounts

  alias WippliBackend.Wippli.Participant

  #Participants
  def create_participant(zone, user, password) do
    with {:ok, true} <- validate_password(zone,password) do
      attrs = %{zone: get_simple_zone!(zone), user: Accounts.get_simple_user!(user)}
      %Participant{}
      |> Participant.changeset(attrs)
      |> Repo.insert!
    else
      {:error, :bad_request} -> %{status: :bad_request, message: "Passwords don't match"}
    end
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

  def get_simple_zone!(id) do
    Repo.get!(Zone, id)
  end

  def get_zone!(id) do
    Repo.get!(Zone, id) |> Repo.preload(:participants)
  end


  def create_zone(attrs \\ %{}, user_id) do
    user = Accounts.get_user!(user_id)
    %Zone{}
    |> Zone.changeset(attrs,user)
    |> Repo.insert()
  end


  def validate_user(zone, user_id) do
    if (zone.created_by == user_id) do
      {:ok, true}
    else
      {:error, :forbidden }
    end

  end

  def validate_password(zone, old_password) do
    if zone.password == old_password do
      {:ok, true}
    else
      {:error, :internal_server_error}
    end
  end

  def update_zone(%Zone{} = zone, attrs) do
    with {:ok, true} <- validate_user(zone, attrs.user_id), {:ok, true} <- validate_password(zone, attrs.old_password) do
      zone
      |> Zone.update_set(attrs)
      |> Repo.update()
    else
      {:error, :internal_server_error} -> {:error, %{status: :internal_server_error, message: "Passwords don't match"}}

      {:error, :forbidden} -> {:error,  %{status: :forbidden, message: "User didn't create this zone"}}

    end
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

  alias WippliBackend.Wippli.Request

  @doc """
  Returns the list of requests.

  ## Examples

      iex> list_requests()
      [%Request{}, ...]

  """
  def list_requests do
    Repo.all(Request)
  end

  @doc """
  Gets a single request.

  Raises `Ecto.NoResultsError` if the Request does not exist.

  ## Examples

      iex> get_request!(123)
      %Request{}

      iex> get_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_request!(id), do: Repo.get!(Request, id)

  @doc """
  Creates a request.

  ## Examples

      iex> create_request(%{field: value})
      {:ok, %Request{}}

      iex> create_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_request(attrs \\ %{}) do
    %Request{}
    |> Request.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a request.

  ## Examples

      iex> update_request(request, %{field: new_value})
      {:ok, %Request{}}

      iex> update_request(request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_request(%Request{} = request, attrs) do
    request
    |> Request.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Request.

  ## Examples

      iex> delete_request(request)
      {:ok, %Request{}}

      iex> delete_request(request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_request(%Request{} = request) do
    Repo.delete(request)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking request changes.

  ## Examples

      iex> change_request(request)
      %Ecto.Changeset{source: %Request{}}

  """
  def change_request(%Request{} = request) do
    Request.changeset(request, %{})
  end
end
