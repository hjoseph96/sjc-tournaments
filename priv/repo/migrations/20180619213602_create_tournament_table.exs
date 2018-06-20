defmodule Sjc.Repo.Migrations.CreateTournamentTable do
  use Ecto.Migration

  def change do
    create table(:tournaments) do
      # add :user_id, references(:users)
      # add :round_id, references(:rounds)
      # add :prize_id, references(:prizes)
      add :point_multiplier, :float
      add :battle_items_allowed, :integer

      timestamps()
    end
  end
end
