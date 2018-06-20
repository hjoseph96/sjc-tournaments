defmodule Sjc.Factory do
  @moduledoc """
  Defines factories to use in tests.
  """

  use ExMachina.Ecto, repo: Sjc.Repo

  alias Sjc.Models.Tournament

  def tournament_factory do
    %Tournament{
      point_multiplier: 12.0,
      battle_items_allowed: 7
    }
  end
end
