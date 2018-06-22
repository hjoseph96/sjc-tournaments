defmodule Sjc.Factory do
  @moduledoc """
  Defines factories to use in tests.
  """

  use ExMachina

  alias Sjc.Game.Player

  def player_factory do
    %{
      id: sequence(:id, & &1 + 1),
      health_points: 50.0,
      shield_points: 40.0,
      accuracy: sequence(:accuracy, & &1 + 17.2),
      luck: sequence(:luck, & &1 + 8.6)
    }
  end
end
