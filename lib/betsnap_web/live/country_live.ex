defmodule BetsnapWeb.CountryLive do
  use BetsnapWeb, :live_view

  alias BetsnapWeb.Api.SportsAPI

  def mount(_params, _session, socket) do
    {:ok, assign(socket, leagues: [], country: %{}, loading_leagues: true, loading_country: true)}
  end

  def handle_params(%{"code" => code}, _uri, socket) do
    with {:ok, %{"response" => country}} <- SportsAPI.get_country(code),
         {:ok, %{"response" => leagues}} <- SportsAPI.get_country_leagues(code) do
      ids = Enum.map(leagues, fn league -> league["league"]["id"] end)
      send(self(), {:country_loaded, Enum.at(country, 0)})

      today = Date.utc_today()
      next_week = Date.add(today, 7)

      leagues =
        Enum.map(ids, fn league_id ->
          case SportsAPI.get_leagues_matches(league_id, today, next_week) do
            {:ok, response} ->
              %{"response" => fixtures} = response
              fixtures

            {:error, _} ->
              {:noreply, assign(socket, loading_leagues: false)}
          end
        end)

      send(self(), {:leagues_loaded, leagues})
      {:noreply, socket}
    else
      {:error, _} ->
        {:noreply, assign(socket, loading_leagues: false)}
    end

    {:noreply, socket}
  end

  def handle_info({:country_loaded, country}, socket) do
    {:noreply, assign(socket, loading_country: false, country: country)}
  end

  def handle_info({:leagues_loaded, leagues}, socket) do
    {:noreply, assign(socket, loading_leagues: false, leagues: leagues)}
  end
end
