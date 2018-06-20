defmodule Sjc.Models do
  @moduledoc """
  Helper functions to interact with the database.
  """

  alias __MODULE__.{Player}
  alias Sjc.Repo

  @doc "Returns all players"
  def all_players do
    Repo.all(Player)
  end

  @doc """
  Gets a player by id.

  Returns 'nil' if no Player was found.
  """
  def get_player(id) do
    Repo.get(Player, id)
  end

  @doc """
  Creates a new player.
  Returns {:ok, %Player{}} | {:error, %Ecto.Changeset{}}
  """
  def create_player(%{} = args) do
    %Player{}
    |> Player.changeset(args)
    |> Repo.insert()
  end

  @doc """
  Updates a player.

  Returns {:ok, %Player{}} | {:error, %Ecto.Changeset{}}
  """
  def update_player(%Player{} = player, attrs) do
    player
    |> Player.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a player.

  Returns {:ok, %Player{}} | {:error, %Ecto.Changeset{}}
  """
  def delete_player(%Player{} = player) do
    Repo.delete(player)
  end

  @doc """
  Returns an %Ecto.Changeset{} for tracking player changes.
  """
  def change_player(%Player{} = player) do
    Player.changeset(player, %{})
  end
end
