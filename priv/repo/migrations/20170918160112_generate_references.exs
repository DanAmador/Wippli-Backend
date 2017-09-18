defmodule WippliBackend.Repo.Migrations.GenerateReferences do
  use Ecto.Migration

  def change do
  #  alter table(:zones) do
     # add :created_by, references(:users), null: false
      #add :user_id, references(:users), null: true
   # end

    alter table(:users) do
      #add :created_zone, references(:zones), null: true
      add :zone_id, references(:zones), null: true
      end
    end
end
