defmodule SjcWeb.Schema do
  @moduledoc """
  Schema for GraphQL.
  """

  use Absinthe.Schema

  alias SjcWeb.GameResolver

  object :round_obj do
    field :number, :integer
  end

  object :player do
    field :health_points, :float
    field :shield_points, :float
    # field :squad_armor_points, :float
    field :accuracy, :float
    field :luck, :float
  end

  object :game do
    field :name, :string
    field :round, :round_obj
    field :players, list_of(:player)
    # field :actions, :array
  end

  input_object :player_input_obj do
    field :health_points, :float
    field :shield_points, :float
    # field :squad_armor_points, :float
    field :accuracy, :float
    field :luck, :float
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

    field :add_player, :game do
      arg :name, non_null(:string)
      arg :attributes, non_null(:player_input_obj)

      resolve &GameResolver.add_player/3
    end
  end

  mutation do
    field :create_game, :game do
      arg :name, non_null(:string)

      resolve &GameResolver.create_game/3
    end
  end
end
