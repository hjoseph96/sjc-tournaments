defmodule Sjc.Factory do
  @moduledoc """
  Defines factories to use in tests.
  """

  use ExMachina.Ecto, repo: Sjc.Repo

  alias Sjc.Models.Player

  def player_factory do
    %Player{}
  end
end
