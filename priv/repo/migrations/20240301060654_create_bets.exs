defmodule Betsnap.Repo.Migrations.CreateBets do
  use Ecto.Migration

  def change do
    create table(:bets) do
      add :fixture_id, :string
      add :bet, :string
      add :value, :string
      add :odd, :decimal
      add :stake, :decimal
      add :earn, :decimal
      add :status, :string
      add :user_id, :string

      timestamps(type: :utc_datetime)
    end
  end
end
