defmodule SjcWeb.GameResolver do
  @moduledoc """
  GraphQL resolver for game processes.
  """

  alias Sjc.Game
  alias Sjc.Supervisors.GameSupervisor

  def get_game(_root, %{name: name}, _res) do
    {:ok, Game.state(name)}
  catch
    :exit, _ ->
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

  def add_player(_root, args, _res) do
    case Game.add_player(args.name, args.attributes) do
      {:ok, :added} -> {:ok, Game.state(args.name)}
      {:error, :already_added} -> {:error, "already added"}
    end
  end

  def remove_player(_root, args, _res) do
    Game.remove_player(args.name, args.id)

    {:ok, Game.state(args.name)}
  end
end
