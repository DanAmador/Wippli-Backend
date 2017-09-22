defmodule WippliBackend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias WippliBackend.Accounts.User


  schema "users" do
    field :phone, :string
    field :telegram_id, :string
    #has_many :zones, WippliBackend.Wippli.Zone, foreign_key: :created_zone
    has_many :zones, WippliBackend.Wippli.Zone, foreign_key: :created_by
    timestamps()
  end


  @required_fields ~w(phone)
  @optional_fields ~w(telegram_id)
  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @required_fields, @optional_fields)
    |> unique_constraint(:phone, name: :phone_not_unique )
  end
end
