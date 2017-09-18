defmodule WippliBackend.Wippli.PlaylistSong do
  use Ecto.Schema
  import Ecto.Changeset
  alias WippliBackend.Wippli.PlaylistSong


  schema "playlist_songs" do
    field :rating, :integer

    timestamps()
  end

  @doc false
  def changeset(%PlaylistSong{} = playlist_song, attrs) do
    playlist_song
    |> cast(attrs, [:rating])
    |> validate_required([:rating])
  end
end
