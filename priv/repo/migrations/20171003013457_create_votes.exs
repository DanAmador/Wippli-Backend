defmodule WippliBackend.Repo.Migrations.CreateVotes do
  use Ecto.Migration
  def change do
    create table(:votes) do
      add :rating, :integer
      add :request_id, references(:requests), null: false
      add :voted_by, references(:users), null: false
      timestamps()
    end
  end
end
