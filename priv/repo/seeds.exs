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
user = %WippliBackend.Accounts.User{phone: "+525542918039"} 
zone = %WippliBackend.Wippli.Zone{password: "fuck" }

WippliBackend.Repo.insert!(zone)

zoneRel = WippliBackend.Wippli.get_zone!(1)
assoc = Ecto.build_assoc(zoneRel, :users, phone: "+525542918039")


WippliBackend.Repo.insert!(assoc)
