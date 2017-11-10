defmodule WippliBackend.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
    create table(:requests) do
      add :times_played, :boolean, default: false

      add :requested_by, references(:users)
     # add :vote_id, references(:votes)
      add :song_id, references(:songs), null: false
      add :zone_id, references(:zones), nulll: false
      timestamps()
    end

  end
end
