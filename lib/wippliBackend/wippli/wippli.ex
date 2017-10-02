defmodule WippliBackend.Wippli do
  @moduledoc """
  The Wippli context.
  """

  import Ecto.Query, warn: false
  alias WippliBackend.Repo
  alias WippliBackend.Accounts

  alias WippliBackend.Wippli.Participant

  #Participants
  def create_participant(attrs) do
    %Participant{}
    |> Participant.changeset(attrs)
    |> Repo.insert!
  end

  def join_zone(zone_id,user,password) do
    zone = get_simple_zone!(zone_id)
    with {:ok, true} <- validate_password(zone,password) do
      %{zone: zone, user: Accounts.get_simple_user!(user)} |> create_participant()
    else
      {:error, :bad_request} -> %{status: :bad_request, message: "Passwords don't match"}
    end
  end
  def get_participant_in_zone(zone_id) do
    Repo.get!(Zone, zone_id)
    |> Repo.preload(:participants)
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
    Repo.get(Zone, id) |> Repo.preload([:participants,requests: :song ] )
  end


  def create_zone(attrs \\ %{}, user_id) do
    user = Accounts.get_simple_user!(user_id)
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


  #Songs
  alias WippliBackend.Wippli.Song
  def list_songs do
    Repo.all(Song)
  end

  def get_song!(url) do
    {:ok, Repo.get_by(Song, url: url)}
  end

  def create_song(attrs \\ %{}) do
    if attrs != {:error, :bad_request} do
      %Song{}
      |> Song.changeset(attrs)
      |> Repo.insert()
    else
      {:error, :bad_request}
    end
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


  #Requests
  alias WippliBackend.Wippli.Request

  defp get_no_embed(url) do
    HTTPotion.get("https://noembed.com/embed?url=#{url}").body |> Poison.decode!
  end

  defp process_youtube_minimized(no_embed_map, uri_struct) do
    id = uri_struct.path |> String.replace("/", "")
     %{title: no_embed_map["title"], thumbnail: no_embed_map["thumbnail_url"], source_id: id, url: uri_struct |> to_string}
  end

  defp process_youtube(no_embed_map, uri_struct) do
    query_map = uri_struct.query |> URI.decode_query
    %{title: no_embed_map["title"], thumbnail: no_embed_map["thumbnail_url"], source_id: query_map["v"], url: uri_struct |> to_string}
  end

  def parse_url(song_url) do
    uri_struct = URI.parse(song_url)
    case uri_struct.host do
      "www.youtube.com" -> get_no_embed(song_url) |> process_youtube(uri_struct)
      "youtu.be" -> get_no_embed(song_url) |> process_youtube_minimized(uri_struct)
      _ -> {:error, :bad_request}
    end
  end

  def list_requests do
    Repo.all(Request)
  end

  defp create_request_from_song(song, user_id, zone_id) do
    if song != {:error, :bad_request} do
      %Request{}
      |> Request.changeset(%{song: song, user: Accounts.get_simple_user!(user_id), zone: get_simple_zone!(zone_id)})
      |> Repo.insert()

    else
      {
        :error, :bad_request
      }
    end
  end

  def get_zone_with_requests!(id) do
    Repo.get(Zone, id) |> Repo.preload(:requests, [requests: :songs])
  end

  #TODO parse url to create a Song changeset
  #TODO modify create_song to be built from changeset
  #TODO create_request_from_song(song_changeset, user_id, song_id) 
  def create_request(user_id, zone_id, song_url) do
    with {:ok, %Song{} = song } <- get_song!(song_url) do
      create_request_from_song(song, user_id, zone_id)
    else
      {:ok, nil} -> parse_url(song_url) |> create_song |> create_request_from_song(user_id, zone_id)
      {:error, :bad_request} -> %{status: :bad_request, message: "URL #{song_url} doesn't match any service"}
    end
  end

  def update_request(%Request{} = request, attrs) do
    request
    |> Request.changeset(attrs)
    |> Repo.update()
  end

  def delete_request(%Request{} = request) do
    Repo.delete(request)
  end

  def change_request(%Request{} = request) do
    Request.changeset(request, %{})
  end
end
