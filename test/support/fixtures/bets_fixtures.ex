defmodule Betsnap.BetsFixtures do
  @moduledoc """
  Module to handle bets fixtures
  """

  def valid_bet_attributes(attrs \\ %{}) do
    %{id: id} = Betsnap.AccountsFixtures.user_fixture()

    Enum.into(
      attrs,
      %{
        "status" => "pending",
        "value" => "Home",
        "fixture_id" => System.unique_integer() |> Integer.to_string(),
        "bet" => "1",
        "odd" => 1.5,
        "stake" => Decimal.from_float(100.0),
        "earn" => 150.0,
        "user_id" => id |> Integer.to_string()
      }
    )
  end

  def bet_fixture(attrs \\ %{}) do
    {:ok, bet} =
      attrs
      |> valid_bet_attributes()
      |> Betsnap.Bets.create_bet()

    bet
  end
end
