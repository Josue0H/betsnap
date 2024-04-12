defmodule Betsnap.Bets do
  @moduledoc """
  Module to handle bets
  """

  use Ecto.Schema
  import Ecto.Query

  alias Betsnap.Accounts.{User}
  alias Betsnap.Accounts
  alias Betsnap.Repo
  alias BetsnapWeb.Services.SportsAPI
  alias BetsnapWeb.Utils.BetChecker

  def create_bet(attrs) do
    case Repo.get(User, attrs["user_id"]) do
      user -> handle_user_found(user, attrs)
      nil -> {:error, "User not found"}
    end
  end

  defp handle_user_found(user, attrs) do
    if Decimal.compare(user.balance, attrs["stake"]) == :lt do
      {:error, "Insufficient balance"}
    else
      handle_transaction(user, attrs)
    end
  end

  defp handle_transaction(user, attrs) do
    Repo.transaction(fn ->
      user
      |> Accounts.add_balance(Decimal.mult(attrs["stake"], -1))

      %Betsnap.Bet{}
      |> Betsnap.Bet.changeset(attrs)
      |> Betsnap.Repo.insert()
    end)
  end

  def get_bets(user_id) do
    bets =
      Betsnap.Repo.all(
        from b in Betsnap.Bet,
          where: b.user_id == ^Integer.to_string(user_id),
          order_by: [desc: b.inserted_at]
      )

    tasks =
      Enum.map(bets, fn bet ->
        Task.async(fn -> SportsAPI.get_match(bet.fixture_id) end)
      end)

    results =
      tasks
      |> Enum.map(&Task.await/1)
      |> Enum.map(fn
        {:ok, %{"response" => match}} -> match
        {:error, _} -> %{}
      end)
      |> Enum.map(fn match -> match |> Enum.at(0) end)

    bets =
      Enum.map(bets, fn bet ->
        match =
          Enum.at(
            Enum.filter(results, fn r ->
              r["fixture"]["id"] == bet.fixture_id |> String.to_integer()
            end),
            0
          )

        info =
          %{}
          |> Map.put(
            :name,
            "#{match["teams"]["home"]["name"]} vs #{match["teams"]["away"]["name"]}"
          )
          |> Map.put(:status, match["fixture"]["status"]["short"])
          |> Map.put(:timestamp, match["fixture"]["timestamp"])
          |> Map.put(:result, "#{match["goals"]["home"]} - #{match["goals"]["away"]}")

        Map.put(bet, :info, info)
      end)

    {:ok, bets}

    # Enum.map(fn bet ->
    #   with {:ok, %{"response" => match}} <- SportsAPI.get_match(bet.fixture_id) do
    #     match = match |> Enum.at(0)

    #     info =
    #       %{}
    #       |> Map.put(
    #         :name,
    #         "#{match["teams"]["home"]["name"]} vs #{match["teams"]["away"]["name"]}"
    #       )
    #       |> Map.put(:status, match["fixture"]["status"]["short"])
    #       |> Map.put(:timestamp, match["fixture"]["timestamp"])
    #       |> Map.put(:result, "#{match["goals"]["home"]} - #{match["goals"]["away"]}")

    #     Map.put(bet, :info, info)
    #   else
    #     {:error, _} -> %{}
    #   end
    # end)

    # {:ok, bets}
  end

  # def validate_all_bets() do
  #   bets =
  #     Betsnap.Repo.all(Betsnap.Bet)
  #     |> Enum.map(fn bet ->
  #       case {:ok, %{"response" => match}} <- SportsAPI.get_match(bet.fixture_id) do
  #         match = match |> Enum.at(0)

  #         if match["fixture"]["status"]["short"] == "FT" do
  #           if bet.status == "pending" do
  #             case BetChecker.check_bet(match, bet.bet, bet.value) do
  #               {:ok, "win"} ->
  #                 bet_changeset =
  #                   bet
  #                   |> Ecto.Changeset.change(%{status: "win"})

  #                 Betsnap.Repo.transaction(fn ->
  #                   Betsnap.Repo.update(bet_changeset)

  #                   user = Repo.get!(User, bet.user_id)

  #                   user
  #                   |> Accounts.add_balance(bet.earn)
  #                 end)

  #                 bet = Betsnap.Repo.get(Betsnap.Bet, bet.id)

  #                 bet

  #               {:ok, "loss"} ->
  #                 bet_changeset =
  #                   bet
  #                   |> Ecto.Changeset.change(%{status: "loss"})

  #                 Betsnap.Repo.update(bet_changeset)

  #                 bet = Betsnap.Repo.get(Betsnap.Bet, bet.id)

  #                 bet

  #               {:error, _} ->
  #                 bet
  #             end
  #           end
  #         end
  #       else
  #         {:error, _} -> %{}
  #       end
  #     end)

  #   {:ok, bets}
  # end

  def validate_all_bets() do
    bets =
      Betsnap.Repo.all(Betsnap.Bet)
      |> Enum.map(fn bet ->
        Task.async(fn -> validate_bet(bet) end)
      end)
      |> Enum.map(&Task.await/1)

    {:ok, bets}
  end

  defp validate_bet(bet) do
    case SportsAPI.get_match(bet.fixture_id) do
      {:ok, %{"response" => match}} ->
        match = match |> Enum.at(0)

        cond do
          match["fixture"]["status"]["short"] == "FT" -> nil
          bet.status == "pending" -> nil
          true -> handle_bet_result(bet, match)
        end

      _ ->
        {:error, "Match not found"}
    end
  end

  defp handle_bet_result(bet, match) do
    case BetChecker.check_bet(match, bet.bet, bet.value) do
      {:ok, "win"} ->
        update_bet_status(bet, "win")
        update_user_balance(bet.earn, bet.user_id)

      {:ok, "loss"} ->
        update_bet_status(bet, "loss")

      {:error, _} ->
        bet
    end
  end

  defp update_bet_status(bet, status) do
    bet
    |> Ecto.Changeset.change(%{status: status})
    |> Betsnap.Repo.update()
  end

  defp update_user_balance(earnings, user_id) do
    user = Repo.get!(User, user_id)

    user
    |> Accounts.add_balance(earnings)
  end

  def delete_bet(id) do
    with bet <- Betsnap.Repo.get(Betsnap.Bet, id),
         user <- Repo.get(User, bet.user_id) do
      Repo.transaction(fn ->
        user
        |> Accounts.add_balance(bet.stake)

        Betsnap.Repo.delete(bet)
      end)
    else
      _ -> {:error, "Bet not found"}
    end
  end
end
