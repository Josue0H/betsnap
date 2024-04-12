defmodule BetsnapWeb.Utils.BetChecker do
  @moduledoc """
  Module to check bets
  """

  @bet_functions %{
    "1" => :match_winner,
    "2" => :home_away,
    "3" => :second_half_winner,
    "5" => :goals_over_under,
    "6" => :goals_over_under_first_half,
    "26" => :goals_over_under_second_half,
    "27" => :clean_sheet_home,
    "28" => :clean_sheet_away,
    "8" => :both_teams_to_score,
    "29" => :win_to_nil_home,
    "30" => :win_to_nil_away,
    "10" => :exact_score
  }

  def check_bet(match, bet, value) do
    IO.puts("Checking bet... #{bet} #{value}")

    case Map.fetch(@bet_functions, bet) do
      {:ok, function} -> apply(__MODULE__, function, [match, value])
      :error -> {:error, "Invalid bet"}
    end
  end

  # def match_winner(match, value) do
  #   case match do
  #     %{"goals" => %{"home" => home_goals, "away" => away_goals}} ->
  #       cond do
  #         home_goals > away_goals && value == "Home" ->
  #           {:ok, "win"}

  #         home_goals == away_goals && value == "Draw" ->
  #           {:ok, "win"}

  #         home_goals < away_goals && value == "Away" ->
  #           {:ok, "win"}

  #         true ->
  #           {:ok, "loss"}
  #       end

  #     _ ->
  #       {:error, "Invalid match"}
  #   end
  # end

  def match_winner(%{"goals" => %{"home" => home_goals, "away" => away_goals}}, value) do
    cond do
      home_goals > away_goals && value == "Home" ->
        {:ok, "win"}

      home_goals == away_goals && value == "Draw" ->
        {:ok, "win"}

      home_goals < away_goals && value == "Away" ->
        {:ok, "win"}

      true ->
        {:ok, "loss"}
    end
  end

  def match_winner(_, _), do: {:error, "Invalid match"}

  def home_away(match, value) do
    case match do
      %{"goals" => %{"home" => home_goals, "away" => away_goals}} ->
        cond do
          home_goals > away_goals && value == "Home" ->
            {:ok, "win"}

          home_goals < away_goals && value == "Away" ->
            {:ok, "win"}

          true ->
            {:ok, "loss"}
        end

      _ ->
        {:error, "Invalid match"}
    end
  end

  # def second_half_winner(match, value) do
  #   case match do
  #     %{"goals" => %{"home" => home_goals, "away" => away_goals}} ->
  #       cond do
  #         home_goals > away_goals && value == "Home" ->
  #           {:ok, "win"}

  #         home_goals == away_goals && value == "Draw" ->
  #           {:ok, "win"}

  #         home_goals < away_goals && value == "Away" ->
  #           {:ok, "win"}

  #         true ->
  #           {:ok, "loss"}
  #       end

  #     _ ->
  #       {:error, "Invalid match"}
  #   end
  # end

  def second_half_winner(%{"goals" => %{"home" => home_goals, "away" => away_goals}}, value) do
    cond do
      home_goals > away_goals && value == "Home" ->
        {:ok, "win"}

      home_goals == away_goals && value == "Draw" ->
        {:ok, "win"}

      home_goals < away_goals && value == "Away" ->
        {:ok, "win"}

      true ->
        {:ok, "loss"}
    end
  end

  def second_half_winner(_, _), do: {:error, "Invalid match"}

  def goals_over_under(match, value) do
    case match do
      %{"goals" => %{"home" => home_goals, "away" => away_goals}} ->
        total_goals = home_goals + away_goals

        betcond =
          String.split(value, " ")
          |> Enum.at(0)

        goals =
          String.split(value, " ")
          |> Enum.at(1)

        cond do
          Decimal.compare(total_goals, goals) === :lt && betcond == "Under" ->
            {:ok, "win"}

          Decimal.compare(total_goals, goals) === :gt && betcond == "Over" ->
            {:ok, "win"}

          true ->
            {:ok, "loss"}
        end

      _ ->
        {:error, "Invalid match"}
    end
  end

  def goals_over_under_first_half(match, value) do
    case match do
      %{"score" => %{"halftime" => %{"home" => home_goals, "away" => away_goals}}} ->
        total_first_half_goals = home_goals + away_goals

        betcond =
          String.split(value, " ")
          |> Enum.at(0)

        goals =
          String.split(value, " ")
          |> Enum.at(1)

        cond do
          Decimal.compare(total_first_half_goals, goals) === :lt && betcond == "Under" ->
            {:ok, "win"}

          Decimal.compare(total_first_half_goals, goals) === :gt && betcond == "Over" ->
            {:ok, "win"}

          true ->
            {:ok, "loss"}
        end

      _ ->
        {:error, "Invalid match"}
    end
  end

  def goals_over_under_second_half(match, value) do
    case match do
      %{
        "goals" => %{"home" => fulltime_home_goals, "away" => fulltime_away_goals},
        "score" => %{"halftime" => %{"home" => home_goals, "away" => away_goals}}
      } ->
        total_second_half_goals =
          fulltime_home_goals + fulltime_away_goals - (home_goals + away_goals)

        betcond =
          String.split(value, " ")
          |> Enum.at(0)

        goals =
          String.split(value, " ")
          |> Enum.at(1)

        cond do
          Decimal.compare(total_second_half_goals, goals) === :lt && betcond == "Under" ->
            {:ok, "win"}

          Decimal.compare(total_second_half_goals, goals) === :gt && betcond == "Over" ->
            {:ok, "win"}

          true ->
            {:ok, "loss"}
        end

      _ ->
        {:error, "Invalid match"}
    end
  end

  def clean_sheet_home(match, value) do
    case match do
      %{"goals" => %{"away" => away_goals}} ->
        cond do
          away_goals == 0 && value == "Yes" ->
            {:ok, "win"}

          away_goals > 0 && value == "No" ->
            {:ok, "win"}

          true ->
            {:ok, "loss"}
        end

      _ ->
        {:error, "Invalid match"}
    end
  end

  def clean_sheet_away(match, value) do
    case match do
      %{"goals" => %{"home" => home_goals}} ->
        cond do
          home_goals == 0 && value == "Yes" ->
            {:ok, "win"}

          home_goals > 0 && value == "No" ->
            {:ok, "win"}

          true ->
            {:ok, "loss"}
        end

      _ ->
        {:error, "Invalid match"}
    end
  end

  # def both_teams_to_score(match, value) do
  #   case match do
  #     %{"goals" => %{"home" => home_goals, "away" => away_goals}} ->
  #       cond do
  #         home_goals > 0 && away_goals > 0 && value == "Yes" ->
  #           {:ok, "win"}

  #         (home_goals == 0 || away_goals == 0) && value == "No" ->
  #           {:ok, "win"}

  #         true ->
  #           {:ok, "loss"}
  #       end

  #     _ ->
  #       {:error, "Invalid match"}
  #   end
  # end

  def both_teams_to_score(%{"goals" => %{"home" => home_goals, "away" => away_goals}}, value) do
    cond do
      home_goals > 0 && away_goals > 0 && value == "Yes" ->
        {:ok, "win"}

      (home_goals == 0 || away_goals == 0) && value == "No" ->
        {:ok, "win"}

      true ->
        {:ok, "loss"}
    end
  end

  def both_teams_to_score(_, _), do: {:error, "Invalid match"}

  # def win_to_nil_home(match, value) do
  #   case match do
  #     %{"goals" => %{"home" => home_goals, "away" => away_goals}} ->
  #       cond do
  #         home_goals > 0 && away_goals == 0 && value == "Yes" ->
  #           {:ok, "win"}

  #         home_goals > 0 && away_goals > 0 && value == "No" ->
  #           {:ok, "win"}

  #         true ->
  #           {:ok, "loss"}
  #       end

  #     _ ->
  #       {:error, "Invalid match"}
  #   end
  # end

  def win_to_nil_home(%{"goals" => %{"home" => home_goals, "away" => away_goals}}, value) do
    cond do
      home_goals > 0 && away_goals == 0 && value == "Yes" ->
        {:ok, "win"}

      home_goals > 0 && away_goals > 0 && value == "No" ->
        {:ok, "win"}

      true ->
        {:ok, "loss"}
    end
  end

  def win_to_nil_home(_, _), do: {:error, "Invalid match"}

  # def win_to_nil_away(%{"goals" => %{"home" => home_goals, "away" => away_goals}} = match, value) do
  #   case match do
  #     %{"goals" => %{"home" => home_goals, "away" => away_goals}} ->
  #       cond do
  #         away_goals > 0 && home_goals == 0 && value == "Yes" ->
  #           {:ok, "win"}

  #         away_goals > 0 && home_goals > 0 && value == "No" ->
  #           {:ok, "win"}

  #         true ->
  #           {:ok, "loss"}
  #       end

  #     _ ->
  #       {:error, "Invalid match"}
  #   end
  # end

  def win_to_nil_away(%{"goals" => %{"home" => home_goals, "away" => away_goals}}, value) do
    cond do
      home_goals = 0 && away_goals > 0 && value == "Yes" ->
        {:ok, "win"}

      home_goals > 0 && away_goals > 0 && value == "No" ->
        {:ok, "win"}

      true ->
        {:ok, "loss"}
    end
  end

  def win_to_nil_away(_, _), do: {:error, "Invalid match"}

  def exact_score(match, value) do
    case match do
      %{"goals" => %{"home" => home_goals, "away" => away_goals}} ->
        bet_home =
          String.split(value, ":")
          |> Enum.at(0)

        bet_away =
          String.split(value, ":")
          |> Enum.at(1)

        if home_goals == bet_home && away_goals == bet_away do
          {:ok, "win"}
        else
          {:ok, "loss"}
        end

      _ ->
        {:error, "Invalid match"}
    end
  end
end
