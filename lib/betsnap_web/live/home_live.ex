defmodule BetsnapWeb.HomeLive do
  use BetsnapWeb, :live_view

  alias BetsnapWeb.Api.SportsAPI

  @premier_league_id 39
  @liga_mx_id 262
  @bundesliga_id 78
  @la_liga_id 140
  @serie_a_id 135

  def mount(_params, _session, socket) do
    elements = [
      %{
        id: 0,
        title: "Best betting site",
        subtitle: "Get the best odds and win big",
        image: "/images/slider/1.jpg"
      },
      %{
        id: 1,
        title: "Best Leagues",
        subtitle: "Bet on the best leagues in the world",
        image: "/images/slider/2.jpg"
      },
      %{
        id: 2,
        title: "Best Teams",
        subtitle: "Bet on the best teams in the world",
        image: "/images/slider/3.jpg"
      }
    ]

    socket =
      assign(
        socket,
        countries: [],
        loading_countries: true,
        leagues: [],
        loading_leagues: true,
        value: 0,
        elements: elements,
        best_leagues: [@liga_mx_id, @premier_league_id, @bundesliga_id, @la_liga_id, @serie_a_id]
      )

    case SportsAPI.get_countries() do
      {:ok, response} ->
        %{"response" => countries} = response
        send(self(), {:countries_loaded, countries})
        {:noreply, socket}

      {:error, _} ->
        {:noreply, assign(socket, loading_countries: false)}
    end

    today = Date.utc_today()
    next_week = Date.add(today, 7)

    best_leagues = [@liga_mx_id, @premier_league_id, @bundesliga_id, @la_liga_id, @serie_a_id]

    leagues =
      Enum.map(best_leagues, fn league_id ->
        case SportsAPI.get_leagues_matches(league_id, today, next_week) do
          {:ok, response} ->
            %{"response" => fixtures} = response
            fixtures

          {:error, _} ->
            {:noreply, assign(socket, loading_leagues: false)}
        end
      end)

    send(self(), {:leagues_loaded, leagues})

    {:ok, socket}
  end

  def handle_info({:countries_loaded, countries}, socket) do
    {:noreply, assign(socket, loading_countries: false, countries: countries)}
  end

  def handle_info({:leagues_loaded, leagues}, socket) do
    {:noreply, assign(socket, loading_leagues: false, leagues: leagues)}
  end

  def handle_info(:next_slide, socket) do
    value = rem(socket.assigns.value + 1, length(socket.assigns.elements))

    {:noreply, assign(socket, :value, value)}
  end
end
