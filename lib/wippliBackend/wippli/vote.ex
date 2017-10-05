defmodule WippliBackend.Wippli.Vote do
  use Ecto.Schema
  import Ecto.Changeset
  alias WippliBackend.Wippli.Vote


  schema "votes" do
    field :rating, :integer
    belongs_to :request, WippliBackend.Wippli.Request
    belongs_to :user, WippliBackend.Accounts.User, foreign_key: :voted_by
    timestamps()
  end

  @required_fields ~w(rating)a
  def changeset(%Vote{} = vote, attrs) do
    vote
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> Ecto.Changeset.put_assoc(:request, attrs.request)
    |> Ecto.Changeset.put_assoc(:user, attrs.user)
  end



  def update_set(%Vote{} = vote, attrs) do
    vote
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
