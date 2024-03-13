defmodule Betsnap.Bets do
  use Ecto.Schema
  import Ecto.Query

  alias Betsnap.Accounts.{User}
  alias Betsnap.Accounts
  alias Betsnap.Repo
  alias BetsnapWeb.Api.SportsAPI
  alias BetsnapWeb.Utils.BetChecker

  def create_bet(attrs) do

    case Repo.get(User, attrs["user_id"]) do
      nil -> {:error, "User not found"}
      user ->
        if Decimal.compare(user.balance, attrs["stake"]) == :lt do
          {:error, "Insufficient balance"}
        else
          Repo.transaction(fn ->
            user
            |> Accounts.add_balance(Decimal.mult(attrs["stake"], -1))

            %Betsnap.Bet{}
            |> Betsnap.Bet.changeset(attrs)
            |> Betsnap.Repo.insert()
          end)
        end
    end

  end

  def get_bets(user_id) do
    bets =
      Betsnap.Repo.all(
        from b in Betsnap.Bet,
          where: b.user_id == ^Integer.to_string(user_id),
          order_by: [desc: b.inserted_at]
      )

    additional_info =
      Enum.map(bets, fn bet ->
        with {:ok, %{"response" => match}} <- SportsAPI.get_match(bet.fixture_id) do
          match = match |> Enum.at(0)

          info =
            %{}
            |> Map.put(
              :name,
              "#{match["teams"]["home"]["name"]} vs #{match["teams"]["away"]["name"]}"
            )
            |> Map.put(:status, match["fixture"]["status"]["short"])
            |> Map.put(:timestamp, match["fixture"]["timestamp"])
            |> Map.put(:result, "#{match["goals"]["home"]} - #{match["goals"]["away"]}")

          if match["fixture"]["status"]["short"] == "FT" do
            if bet.status == "pending" do
              case BetChecker.check_bet(match, bet.bet, bet.value) do
                {:ok, "win"} ->
                  bet_changeset =
                    bet
                    |> Ecto.Changeset.change(%{status: "win"})

                  Betsnap.Repo.transaction(fn ->
                    Betsnap.Repo.update(bet_changeset)

                    user = Repo.get!(User, bet.user_id)

                    user
                    |> Accounts.add_balance(bet.earn)
                  end)

                  bet = Betsnap.Repo.get(Betsnap.Bet, bet.id)

                  Map.put(bet, :info, info)

                {:ok, "loss"} ->
                  bet_changeset =
                    bet
                    |> Ecto.Changeset.change(%{status: "loss"})

                  Betsnap.Repo.update(bet_changeset)

                  bet = Betsnap.Repo.get(Betsnap.Bet, bet.id)

                  Map.put(bet, :info, info)

                {:error, _} ->
                  Map.put(bet, :info, info)
              end
            else
              Map.put(bet, :info, info)
            end
          else
            Map.put(bet, :info, info)
          end
        else
          {:error, _} -> %{}
        end
      end)

    {:ok, additional_info}
  end

  def delete_bet(id) do

    case Betsnap.Repo.get(Betsnap.Bet, id) do
      nil -> {:error, "Bet not found"}
      bet ->
        case Repo.get(User, bet.user_id) do
          nil -> {:error, "User not found"}
          user ->
            Repo.transaction(fn ->
              user
              |> Accounts.add_balance(bet.stake)

              Betsnap.Repo.delete(bet)
            end)

        end
    end
  end
end
