# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WippliBackend.Repo.insert!(%WippliBackend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias WippliBackend.Accounts
alias WippliBackend.Wippli


Accounts.create_user(%{phone: "52345234"})
Accounts.create_user(%{phone: "534223423"})
Wippli.create_zone(%{password: "fuck"}, 1)
Wippli.join_zone(1,1, "fuck")
Wippli.create_request(1,1,"https://youtu.be/PLIJc7YE_jw")
