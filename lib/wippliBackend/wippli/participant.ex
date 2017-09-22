defmodule WippliBackend.Wippli.Participant do  
  use Ecto.Schema
  import Ecto.Changeset
  alias WippliBackend.Wippli.Participant

  schema "participants" do
    belongs_to :user, WippliBackend.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(%Participants{} = participants, attrs) do
    participants
    |> cast(attrs, [])
    |> validate_required([])
    |> Ecto.Changeset.put_assoc(:user, attrs.user)
    # |> Ecto.Changeset.put_assoc(:zone, attrs.zone)
  end
end
