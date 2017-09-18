defmodule WippliBackend.Repo.Migrations.CreatePlaylistSongs do
  use Ecto.Migration

  def change do
    create table(:playlist_songs) do
      add :rating, :integer

      timestamps()
    end

  end
end
