# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Sjc.Repo.insert!(%Sjc.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Sjc.Models.Tournament
alias Sjc.Repo

%Tournament{point_multiplier: 12.0, battle_items_allowed: 2}
|> Repo.insert!()
