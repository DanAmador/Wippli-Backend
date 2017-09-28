defmodule WippliBackend.Wippli.Vote do
  use Ecto.Schema
  import Ecto.Changeset
  alias WippliBackend.Wippli.Vote


  schema "votes" do
    field :rating, :integer
    belongs_to :request, WippliBackend.Wippli.Request
    timestamps()
  end

  @doc false
  def changeset(%Vote{} = vote, attrs) do
    vote
    |> cast(attrs, [:rating])
    |> validate_required([:rating])
  end
end
