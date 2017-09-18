defmodule WippliBackend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :phone, :string
      add :telegram_id, :string
      timestamps()
    end

  end
end
