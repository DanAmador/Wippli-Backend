defmodule WippliBackend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias WippliBackend.Accounts.User


  schema "users" do
    field :phone, :string
    field :telegram_id, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:phone, :telegram_id])
    |> validate_required([:phone, :telegram_id])
  end
end
