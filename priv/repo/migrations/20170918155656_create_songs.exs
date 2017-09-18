defmodule WippliBackend.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :title, :string
      add :source, :integer
      add :source_id, :string
      add :thumbnail, :string

      timestamps()
    end

  end
end
