# defmodule Sjc.ModelsTest do
#   @moduledoc false

#   use Sjc.DataCase

#   alias Sjc.Models
#   alias Sjc.Models.Player

#   setup do
#     player = insert(:player)
#     tournament_params = params_for(:player)

#     {:ok, tournament_params: tournament_params, player: player}
#   end

#   describe "models" do
#     test "returns all players", %{player: players} do
#       tournaments_available = Models.all_players()

#       assert tournaments_available == [players]
#     end

#     test "creates a player", %{tournament_params: params} do
#       assert {:ok, %Player{}} = Models.create_player(params)
#     end

#     test "updates a player", %{player: player} do
#       assert {:ok, %Player{}} = Models.update_player(player, %{point_multiplier: 3.0})
#     end

#     test "deletes a player", %{player: player} do
#       assert {:ok, %Player{}} = Models.delete_player(player)
#     end

#     test "returns a player changeset", %{player: player} do
#       assert %Ecto.Changeset{} = Models.change_player(player)
#     end
#   end
# end
