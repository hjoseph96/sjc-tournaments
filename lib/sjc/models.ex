defmodule Sjc.Models do
  @moduledoc """
  Helper functions to interact with the database.
  """

  alias __MODULE__.{Tournament}
  alias Sjc.Repo

  @doc "Returns all tournaments"
  def all_tournaments do
    Repo.all(Tournament)
  end

  @doc """
  Gets a tournament by id.

  Returns 'nil' if no Tournament was found.
  """
  def get_tournament(id) do
    Repo.get(Tournament, id)
  end

  @doc """
  Creates a new tournament.
  Returns {:ok, %Tournament{}} | {:error, %Ecto.Changeset{}}
  """
  def create_tournament(%{} = args) do
    %Tournament{}
    |> Tournament.changeset(args)
    |> Repo.insert()
  end

  @doc """
  Updates a tournament.

  Returns {:ok, %Tournament{}} | {:error, %Ecto.Changeset{}}
  """
  def update_tournament(%Tournament{} = tournament, attrs) do
    tournament
    |> Tournament.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tournament.

  Returns {:ok, %Tournament{}} | {:error, %Ecto.Changeset{}}
  """
  def delete_tournament(%Tournament{} = tournament) do
    Repo.delete(tournament)
  end

  @doc """
  Returns an %Ecto.Changeset{} for tracking tournament changes.
  """
  def change_tournament(%Tournament{} = tournament) do
    Tournament.changeset(tournament, %{})
  end
end
