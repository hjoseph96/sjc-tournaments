defmodule Sjc.GameTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Sjc.Game

  setup do
    Game.start_link(:game)
    :ok
  end

  describe "game" do
    test "adds another round to the game" do
      Game.next_round(:game)

      assert Game.state(:game).round.number == 2
    end
  end
end
