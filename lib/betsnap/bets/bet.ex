defmodule Betsnap.Bet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bets" do
    field :status, :string
    field :value, :string
    field :fixture_id, :string
    field :bet, :string
    field :odd, :decimal
    field :stake, :decimal
    field :earn, :decimal
    field :user_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bet, attrs) do
    bet
    |> cast(attrs, [:user_id, :fixture_id, :bet, :value, :odd, :stake, :earn, :status])
    |> validate_required([:user_id, :fixture_id, :bet, :value, :odd, :stake, :earn, :status])
  end
end
