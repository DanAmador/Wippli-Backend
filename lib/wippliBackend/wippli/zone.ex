defmodule WippliBackend.Wippli.Zone do
  use Ecto.Schema
  import Ecto.Changeset
  alias WippliBackend.Wippli.Zone


  schema "zones" do
    field :password, :string
    #has_one :user, WippliBackend.Accounts.User, foreign_key: :created_by
    has_many :users, WippliBackend.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(%Zone{} = zone, attrs) do
    zone
    |> cast(attrs, [:password])
    |> validate_required([:password])
  end
end
