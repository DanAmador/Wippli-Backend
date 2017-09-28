defmodule WippliBackend.Wippli.Request do
  use Ecto.Schema
  import Ecto.Changeset
  alias WippliBackend.Wippli.Request


  schema "requests" do
    belongs_to :user, WippliBackend.Accounts.User, foreign_key: :requested_by
    belongs_to :zone, WippliBackend.Wippli.Zone
    belongs_to :song, WippliBackend.Wippli.Song
    has_many :votes, WippliBackend.Wippli.Vote

    timestamps()
  end

  @doc false
  def changeset(%Request{} = request, attrs) do
    request
    |> cast(attrs, [])
    |> validate_required([])
  end
end
