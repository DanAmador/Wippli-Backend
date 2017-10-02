defmodule WippliBackend.Wippli.Song do
  use Ecto.Schema
  import Ecto.Changeset
  alias WippliBackend.Wippli.Song


  schema "songs" do
    field :thumbnail, :string
    field :title, :string
    field :source_id, :string
    field :url, :string
    has_many :requests, WippliBackend.Wippli.Request
    timestamps()
  end


  @required_fields ~w(title source_id thumbnail url)a
  def changeset(%Song{} = song, attrs) do
    song
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
