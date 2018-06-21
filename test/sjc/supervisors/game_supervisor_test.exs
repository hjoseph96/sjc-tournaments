defmodule Sjc.Supervisors.GameSupervisorTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Sjc.Supervisors.GameSupervisor
  alias Sjc.Game

  describe "Game supervisor" do
    test "Initializes game process correctly" do
      assert {:ok, pid} = GameSupervisor.start_child("game_3")
      assert is_pid(pid)
    end

    test "Terminates the given process" do
      {:ok, pid} = GameSupervisor.start_child("game_4")
      # Process is started at this point
      GameSupervisor.stop_child("game_4")

      refute Process.alive?(pid)
      assert is_pid(pid)
      assert catch_exit(Game.state("game_4"))
    end
  end
end
