defmodule SjcWeb.Resolvers.TournamentsResolver do
  @moduledoc false

  alias Sjc.Models

  def all_tournaments(_root, _args, _info) do
    tournaments = Models.all_tournaments()
    {:ok, tournaments}
  end

  def create_tournament(_root, args, _info) do
    case Models.create_tournament(args) do
      {:ok, tournament} -> {:ok, tournament}
      {:error, _} -> {:error, "couldn't create the tournament"}
    end
  end
end
