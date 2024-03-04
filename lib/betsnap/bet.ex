defmodule Betsnap.Bet do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Betsnap.Accounts.{User}
  alias Betsnap.Accounts
  alias Betsnap.Repo
  alias BetsnapWeb.Api.SportsAPI
  alias BetsnapWeb.Utils.BetChecker

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

  def create_bet(attrs) do
    user = Repo.get!(User, attrs["user_id"])

    if user.balance < attrs["stake"] do
      {:error, "Insufficient balance"}
    end

    Repo.transaction(fn ->
      user = Repo.get!(User, attrs["user_id"])
      user
      |> Accounts.add_balance(Decimal.mult(attrs["stake"], -1))

      %Betsnap.Bet{}
      |> Betsnap.Bet.changeset(attrs)
      |> Betsnap.Repo.insert()
    end)

  end


  def get_bets(user_id) do
    bets = Betsnap.Repo.all(from b in Betsnap.Bet, where: b.user_id == ^Integer.to_string(user_id), order_by: [desc: b.inserted_at])


    additional_info = Enum.map(bets, fn bet ->
      {:ok, %{"response" => match}} = SportsAPI.get_match(bet.fixture_id)
      match = match |> Enum.at(0)

      info =
        %{}
        |> Map.put(:name, "#{match["teams"]["home"]["name"]} vs #{match["teams"]["away"]["name"]}")
        |> Map.put(:status, match["fixture"]["status"]["short"])
        |> Map.put(:timestamp, match["fixture"]["timestamp"])
        |> Map.put(:result, "#{match["goals"]["home"]} - #{match["goals"]["away"]}")

      IO.inspect info

      if match["fixture"]["status"]["short"] == "FT" do
        if bet.status == "pending" do
          case BetChecker.check_bet(match, bet.bet, bet.value) do
            {:ok, "win"} ->
              bet_changeset = bet
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
              bet_changeset = bet
                |> Ecto.Changeset.change(%{status: "loss"})

              Betsnap.Repo.update(bet_changeset)

              bet = Betsnap.Repo.get(Betsnap.Bet, bet.id)

              Map.put(bet, :info, info)

            {:error, _} -> Map.put(bet, :info, info)
          end
        else
          Map.put(bet, :info, info)
        end
      else
        Map.put(bet, :info, info)
      end

    end)

    additional_info
  end

  def delete_bet(id) do
    bet = Betsnap.Repo.get(Betsnap.Bet, id)

    user = Repo.get!(User, bet.user_id)
    user
    |> Accounts.add_balance(bet.stake)

    Betsnap.Repo.delete(bet)
  end


end
