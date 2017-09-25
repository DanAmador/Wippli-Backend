defmodule Wippli.Factory do
  use Wippli.UserFactory
  use ExMachina.Ecto, repo: WippliBackend.Repo
end
