defmodule WippliBackend.Repo.Migrations.CreateParticipant do
  use Ecto.Migration

  def change do
    create table(:participant) do
      add :user_id, references(:users, on_delete: :nothing)
      add :zone_id, references(:zones, on_delete: :nothing)

      timestamps()
    end

    create index(:participant, [:user_id])
    create index(:participant, [:zone_id])
  end
end
