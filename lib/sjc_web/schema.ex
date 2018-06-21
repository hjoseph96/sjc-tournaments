defmodule SjcWeb.Schema do
  @moduledoc """
  Schema for GraphQL.
  """

  use Absinthe.Schema

  alias SjcWeb.GameResolver

  object :round_obj do
    field :number, :integer
  end

  object :game do
    field :name, :string
    field :round, :round_obj
    # field :players, :array
    # field :actions, :array
  end

  query do
    field :get_game, :game do
      arg :name, non_null(:string)

      resolve &GameResolver.get_game/3
    end

    field :stop_game, :game do
      arg :name, non_null(:string)

      resolve &GameResolver.stop_game/3
    end

    field :next_round, :game do
      arg :name, non_null(:string)

      resolve &GameResolver.next_round/3
    end
  end

  mutation do
    field :create_game, :game do
      arg :name, non_null(:string)

      resolve &GameResolver.create_game/3
    end
  end
end
