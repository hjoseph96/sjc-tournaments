defmodule Sjc.GameTest do
  @moduledoc false

  use Sjc.DataCase

  import ExUnit.CaptureLog

  alias Sjc.Supervisors.GameSupervisor
  alias Sjc.Game

  setup do
    player_attributes = build(:player)

    {:ok, player_attrs: player_attributes}
  end

  describe "game" do
    test "adds another round to the game" do
      GameSupervisor.start_child("game_1")

      # True by default, changes it to false so it doesn't call next round automatically.
      Game.shift_automatically("game_1")

      Game.next_round("game_1")

      assert Game.state("game_1").round.number == 2
    end

    test "process dies after specified time" do
      # Timeout in test is just 1 second, 1 hour normally.
      {:ok, pid} = GameSupervisor.start_child("game_2")

      Game.shift_automatically("game_2")

      assert Process.alive?(pid)

      # Don't send message in more time than the timeout specified
      :timer.sleep(2000)

      refute Process.alive?(pid)
    end

    test "creates a player struct correctly", %{player_attrs: attributes} do
      GameSupervisor.start_child("game_1")

      assert {:ok, :added} = Game.add_player("game_1", attributes)
      assert length(Game.state("game_1").players) == 1
    end

    test "returns {:error, already added} when player is a duplicate", %{player_attrs: attributes} do
      GameSupervisor.start_child("game_5")

      assert {:ok, :added} = Game.add_player("game_5", attributes)
      assert {:error, :already_added} = Game.add_player("game_5", attributes)
    end

    test "sends :care_package message to process each N amount of rounds" do
      # Round numbers are specified in the process state
      {:ok, _} = GameSupervisor.start_child("game_6")

      fun = fn -> Enum.map(1..2, fn _ -> Game.next_round("game_6") end) end

      assert capture_log(fun) =~ "[RECEIVED] CARE PACKAGE"
    end

    test "removes player from game by identifier", %{player_attrs: attributes} do
      {:ok, _} = GameSupervisor.start_child("game_7")
      {:ok, :added} = Game.add_player("game_7", attributes)

      players_fn = fn -> length(Game.state("game_7").players) end

      # Player length at this point
      assert players_fn.() == 1

      Game.remove_player("game_7", attributes.id)

      assert players_fn.() == 0
    end

    test "automatically shifts round when a specified amount of time has passed" do
      {:ok, _} = GameSupervisor.start_child("game_8")

      assert Game.state("game_8").round.number >= 1
    end
  end
end
