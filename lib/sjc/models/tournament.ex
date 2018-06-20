defmodule Sjc.Models.Tournament do
  @moduledoc """
  Main schema for the Tournament table
  """

  use Ecto.Schema

  import Ecto.Changeset

  schema "tournaments" do
    field(:point_multiplier, :float)
    field(:battle_items_allowed, :integer)

    timestamps()
  end

  def changeset(%__MODULE__{} = tournament, %{} = args) do
    tournament
    |> cast(args, ~w(point_multiplier battle_items_allowed)a)
    |> validate_required(~w(point_multiplier battle_items_allowed)a)
  end
end
