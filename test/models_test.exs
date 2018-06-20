defmodule Sjc.ModelsTest do
  @moduledoc false

  use Sjc.DataCase

  alias Sjc.Models
  alias Sjc.Models.Tournament

  setup do
    tournament = insert(:tournament)
    tournament_params = params_for(:tournament)

    {:ok, tournament_params: tournament_params, tournament: tournament}
  end

  describe "models" do
    test "returns all tournaments", %{tournament: tournaments} do
      tournaments_available = Models.all_tournaments()

      assert tournaments_available == [tournaments]
    end

    test "creates a tournament", %{tournament_params: params} do
      assert {:ok, %Tournament{}} = Models.create_tournament(params)
    end

    test "updates a tournament", %{tournament: tournament} do
      assert {:ok, %Tournament{}} = Models.update_tournament(tournament, %{point_multiplier: 3.0})
    end

    test "deletes a tournament", %{tournament: tournament} do
      assert {:ok, %Tournament{}} = Models.delete_tournament(tournament)
    end

    test "returns a tournament changeset", %{tournament: tournament} do
      assert %Ecto.Changeset{} = Models.change_tournament(tournament)
    end
  end
end
