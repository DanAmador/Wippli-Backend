defmodule WippliBackend.Wippli.Zone do
  use Ecto.Schema
  import Ecto.Changeset
  alias WippliBackend.Wippli.Zone


  schema "zones" do
    field :password, :string
    belongs_to :user, WippliBackend.Accounts.User, foreign_key: :created_by
    has_many :participants, WippliBackend.Wippli.Participant
    timestamps()
  end

  @required_fields ~w(password)a
  @doc false
  def changeset(%Zone{} = zone, attrs, user \\ %{}) do
    zone
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> Ecto.Changeset.put_assoc(:user, user)
  end

  def update_set(%Zone{} = zone, attrs) do
    zone
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
