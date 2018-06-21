defmodule SjcWeb.GameResolver do
  @moduledoc """
  GraphQL resolver for game processes.
  """

  alias Sjc.Game
  alias Sjc.Supervisors.GameSupervisor

  def get_game(_root, %{name: name}, _res) do
    {:ok, Game.state(name)}

  catch :exit, _ ->
    {:error, "not found"}
  end

  def create_game(_root, %{name: name}, _res) do
    GameSupervisor.start_child(name)

    {:ok, Game.state(name)}
  end

  def stop_game(_root, %{name: name}, _res) do
    game_state = Game.state(name)
    GameSupervisor.stop_child(name)

    {:ok, game_state}
  end

  def next_round(_root, %{name: name}, _res) do
    Game.next_round(name)

    {:ok, Game.state(name)}
  end
end
