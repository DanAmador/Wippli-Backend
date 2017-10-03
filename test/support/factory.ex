defmodule Wippli.Factory do
  use Wippli.UserFactory
  use Wippli.ZoneFactory
  use Wippli.SongFactory
  use Wippli.RequestFactory
  use ExMachina.Ecto, repo: WippliBackend.Repo
end
