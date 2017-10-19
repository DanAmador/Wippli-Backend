defmodule WippliBackend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :phone, :string
      add :telegram_id, :integer
      add :nickname, :string
      timestamps()
    end

    create unique_index(:users, :phone, name: :unique_phone)
    create unique_index(:users, :telegram_id, name: :unique_telegram_id)
  end
end
