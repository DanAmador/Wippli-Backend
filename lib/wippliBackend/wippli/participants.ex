defmodule WippliBackend.Wippli.Participants do
  use Ecto.Schema
  import Ecto.Changeset
  alias WippliBackend.Wippli.Participants


  schema "participant" do
    field :user_id, :id
    field :zone_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Participants{} = participants, attrs) do
    participants
    |> cast(attrs, [])
    |> validate_required([])
    |> Ecto.Changeset.put_assoc(:zone, attrs.zone)
    |> Ecto.Changeset.put_assoc(:user, attrs.user)
  end
end
