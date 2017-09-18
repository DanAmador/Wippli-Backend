defmodule WippliBackend.Wippli.Vote do
  use Ecto.Schema
  import Ecto.Changeset
  alias WippliBackend.Wippli.Vote


  schema "votes" do
    field :rating, :integer

    timestamps()
  end

  @doc false
  def changeset(%Vote{} = vote, attrs) do
    vote
    |> cast(attrs, [:rating])
    |> validate_required([:rating])
  end
end
