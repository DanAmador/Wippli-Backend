defmodule WippliBackend.Wippli.Song do
  use Ecto.Schema
  import Ecto.Changeset
  alias WippliBackend.Wippli.Song


  schema "songs" do
    field :thumbnail, :string
    field :title, :string
    field :source_id, :string
    has_many :requests, WippliBackend.Wippli.Request
    timestamps()
  end

  @doc false
  def changeset(%Song{} = song, attrs) do
    song
    |> cast(attrs, [:title, :source, :source_id, :thumbnail, :url])
    |> validate_required([:title, :source, :source_id, :thumbnail, :url])
  end
end
