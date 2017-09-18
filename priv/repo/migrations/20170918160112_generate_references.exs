defmodule WippliBackend.Repo.Migrations.GenerateReferences do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :connected_to, references(:zones)
    end

    alter table(:zones) do
      add :created_by, references(:users)
    end

    alter table(:songs) do
      add :zone_id, references(:zones)
    end

    alter table(:votes) do
      add :by_id, references(:users)
      add :to_id, references(:songs)
      add :in_zone, references(:zones)
    end

    alter table(:playlist_songs) do
      add :song, references(:songs)
      add :requested_by, references(:users)
      add :to_zone, references(:zones)
    end
  end
end
