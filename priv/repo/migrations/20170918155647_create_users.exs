defmodule WippliBackend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :phone, :string
      add :telegram_id, :string
      add :nickname, :string
      timestamps()
    end

    create unique_index(:users, :phone, name: :phone_not_unique)
    create unique_index(:users, :telegram_id, name: :telegram_unique)
  end
end
