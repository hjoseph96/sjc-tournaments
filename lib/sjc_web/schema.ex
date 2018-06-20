defmodule SjcWeb.Schema do
  @moduledoc """
  Schema for GraphQL.
  """

  use Absinthe.Schema

  alias SjcWeb.Resolvers.TournamentsResolver

  object :tournament do
    field :id, non_null(:id)
    field :point_multiplier, non_null(:float)
    field :battle_items_allowed, non_null(:integer)
  end

  query do
    field :all_tournaments, non_null(list_of(non_null(:tournament))) do
      resolve &TournamentsResolver.all_tournaments/3
    end
  end

  mutation do
    field :create_tournament, :tournament do
      arg :point_multiplier, non_null(:float)
      arg :battle_items_allowed, non_null(:integer)

      resolve &TournamentsResolver.create_tournament/3
    end
  end
end
