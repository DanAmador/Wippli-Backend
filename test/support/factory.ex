defmodule Wippli.Factory do
  use Wippli.UserFactory
  use Wippli.ZoneFactory
  use Wippli.SongFactory
  use ExMachina.Ecto, repo: WippliBackend.Repo
end
