defmodule WippliBackend.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :rating, :integer

      timestamps()
    end

  end
end
