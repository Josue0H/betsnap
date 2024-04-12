defmodule Betsnap.BetsTest do
  use Betsnap.DataCase, async: true

  alias Betsnap.Bets

  import Betsnap.BetsFixtures
  import Betsnap.AccountsFixtures

  describe "create_bet/1" do
    test "create a bet" do
      %{id: id} = user_fixture()

      bet = %{
        "status" => "pending",
        "value" => "Home",
        "fixture_id" => System.unique_integer() |> Integer.to_string(),
        "bet" => "1",
        "odd" => 1.5,
        "stake" => Decimal.from_float(100.0),
        "earn" => 150.0,
        "user_id" => id |> Integer.to_string()
      }

      assert {:ok, _} = Bets.create_bet(bet)
    end

    test "error when user doesn't exist" do
      %{id: id} = user_fixture()

      bet = %{
        "status" => "pending",
        "value" => "Home",
        "fixture_id" => System.unique_integer() |> Integer.to_string(),
        "bet" => "1",
        "odd" => 1.5,
        "stake" => Decimal.from_float(100.0),
        "earn" => 150.0,
        "user_id" => (id * 2) |> Integer.to_string()
      }

      assert {:error, _} = Bets.create_bet(bet)
    end

    test "error when user has insufficient balance" do
      %{id: id} = user_fixture()

      bet = %{
        "status" => "pending",
        "value" => "Home",
        "fixture_id" => System.unique_integer() |> Integer.to_string(),
        "bet" => "1",
        "odd" => 1.5,
        "stake" => Decimal.from_float(2000.0),
        "earn" => 1500.0,
        "user_id" => id |> Integer.to_string()
      }

      assert {:error, "Insufficient balance"} = Bets.create_bet(bet)
    end
  end

  describe "get_bets/1" do
    test "get bets" do
      {:ok, bet} = bet_fixture()

      id = bet.user_id |> Integer.parse() |> elem(0)

      assert {:ok, _} = Bets.get_bets(id)
    end

    test "empty array when user doesn't exist" do
      {:ok, bet} = bet_fixture()

      id = bet.user_id |> Integer.parse() |> elem(0)

      assert {:ok, []} = Bets.get_bets(id * 2)
    end

    test "empty array when user has no bets" do
      user = user_fixture()

      id = user.id

      assert {:ok, []} = Bets.get_bets(id)
    end
  end

  describe "delete_bet/1" do
    test "delete a bet" do
      {:ok, bet} = bet_fixture()

      assert {:ok, _} = Bets.delete_bet(bet.id)
    end

    test "error when bet doesn't exist" do
      assert {:error, "Bet not found"} = Bets.delete_bet(0)
    end
  end
end
