defmodule WippliBackend.Repo.Migrations.CreateParticipants do
  use Ecto.Migration

  def change do
    create table(:participants) do
      add :user_id, references(:users)
      add :zone_id, references(:zones)
      timestamps()
    end

  end
end
