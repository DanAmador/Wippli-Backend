defmodule WippliBackend.Repo.Migrations.CreateParticipants do
  use Ecto.Migration

  def change do
    create table(:participants) do

      timestamps()
    end

  end
end
