defmodule SjcWeb.Schema do
  @moduledoc """
  Schema for GraphQL.
  """

  use Absinthe.Schema

  alias SjcWeb.{GameResolver, AuthResolver}

  object :round_obj do
    field :number, :integer
  end

  object :player do
    field :id, :id
    field :health_points, :float
    field :shield_points, :float
    # field :squad_armor_points, :float
    field :accuracy, :float
    field :luck, :float
  end

  object :special_rules_obj do
    field :care_package, :integer
  end

  object :game do
    field :name, :string
    field :round, :round_obj
    field :players, list_of(:player)
    field :special_rules, :special_rules_obj
    # field :actions, :array
  end

  object :auth do
    field :token, :string
  end

  input_object :player_input_obj do
    import_fields :player
  end

  query do
    field :get_game, :game do
      arg :name, non_null(:string)

      resolve &GameResolver.get_game/3
    end

    field :get_auth, :auth do
      arg :identifier, non_null(list_of(:string))

      resolve &AuthResolver.get_auth/3
    end
  end

  mutation do
    field :create_game, :game do
      arg :name, non_null(:string)

      resolve &GameResolver.create_game/3
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

    field :remove_player, :game do
      arg :name, non_null(:string)
      arg :id, non_null(:id)

      resolve &GameResolver.remove_player/3
    end
  end
end
