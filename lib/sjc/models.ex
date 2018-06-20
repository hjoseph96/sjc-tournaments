defmodule Sjc.Models do
  @moduledoc """
  Helper functions to interact with the database.
  """

  alias __MODULE__.{Tournament}
  alias Sjc.Repo

  def all_tournaments do
    Repo.all(Tournament)
  end

  def create_tournament(%{} = args) do
    %Tournament{}
    |> Tournament.changeset(args)
    |> Repo.insert()
  end
end
