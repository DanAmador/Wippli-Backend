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


#Created user and make said user create a zone 

%WippliBackend.Accounts.User{phone: "+525542918039"} |> WippliBackend.Repo.insert!
%WippliBackend.Accounts.User{phone: "+fuck"} |> WippliBackend.Repo.insert!


WippliBackend.Accounts.get_user!(1) |> Ecto.build_assoc(:zones, password: "fuck") |> WippliBackend.Repo.insert!
WippliBackend.Accounts.get_user!(1) |> Ecto.build_assoc(:zones, password: "second zone") |> WippliBackend.Repo.insert!
#Create a second user and add him as a participant 
