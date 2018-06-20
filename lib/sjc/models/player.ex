defmodule Sjc.Models.Player do
  @moduledoc """
  Main schema for the Player table
  """

  use Ecto.Schema

  import Ecto.Changeset

  schema "players" do
    field(:point_multiplier, :float)
    field(:battle_items_allowed, :integer)

    timestamps()
  end

  def changeset(%__MODULE__{} = player, %{} = args) do
    player
    |> cast(args, ~w(point_multiplier battle_items_allowed)a)
    |> validate_required(~w(point_multiplier battle_items_allowed)a)
  end
end
