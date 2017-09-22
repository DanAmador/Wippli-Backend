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

%WippliBackend.Accounts.User{phone: "fuck this shit"} |> WippliBackend.Repo.insert!

