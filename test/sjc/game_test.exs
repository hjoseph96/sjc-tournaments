defmodule Sjc.GameTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Sjc.Supervisors.GameSupervisor
  alias Sjc.Game

  setup do
    Game.start_link("game_1")
    :ok
  end

  describe "game" do
    test "adds another round to the game" do
      Game.next_round("game_1")

      assert Game.state("game_1").round.number == 2
    end

    test "process dies after specified time" do
      # Timeout in test is just 1 second, 1 hour normally.
      {:ok, pid} = GameSupervisor.start_child("game_2")
      assert Process.alive?(pid)

      # Don't send message in more time than the timeout specified
      :timer.sleep(650)

      refute Process.alive?(pid)
    end

    test "creates a player struct correctly" do
      attributes = %{
        accuracy: 5.2,
        health_points: 100.0,
        luck: 4.8,
        shield_points: 100.0
      }

      assert {:ok, :added} = Game.add_player("game_1", attributes)
      assert length(Game.state("game_1").players) == 1
    end

    test "returns {:error, already added} when player is a duplicate" do
      GameSupervisor.start_child("game_5")

      attributes = %{
        accuracy: 5.2,
        health_points: 100.0,
        luck: 4.8,
        shield_points: 100.0
      }

      assert {:ok, :added} = Game.add_player("game_5", attributes)
      assert {:error, :already_added} = Game.add_player("game_5", attributes)
    end
  end
end
