defmodule WippliBackend.Wippli.Song do
  use Ecto.Schema
  import Ecto.Changeset
  alias WippliBackend.Wippli.Song


  schema "songs" do
    field :source, :integer
    field :source_id, :string
    field :thumbnail, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Song{} = song, attrs) do
    song
    |> cast(attrs, [:title, :source, :source_id, :thumbnail])
    |> validate_required([:title, :source, :source_id, :thumbnail])
  end
end
