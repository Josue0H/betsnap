defmodule BetsnapWeb.CountryLive do
  use BetsnapWeb, :live_view

  alias BetsnapWeb.Services.SportsAPI

  def mount(_params, _session, socket) do
    {:ok, assign(socket, leagues: [], country: %{}, loading_leagues: true, loading_country: true)}
  end

  def handle_params(%{"code" => code}, _uri, socket) do
    handle_country_loading(code, socket)
    handle_leagues_loading(code, socket)
  end

  defp handle_country_loading(code, socket) do
    case SportsAPI.get_country(code) do
      {:ok, %{"response" => country}} ->
        send(self(), {:country_loaded, Enum.at(country, 0)})

      {:error, _} ->
        {:noreply, assign(socket, loading_country: false)}
    end
  end

  defp handle_leagues_loading(code, socket) do
    case SportsAPI.get_country_leagues(code) do
      {:ok, %{"response" => leagues}} ->
        today = Date.utc_today()
        next_week = Date.add(today, 7)

        results =
          Enum.map(leagues, fn league -> league["league"]["id"] end)
          |> Enum.map(fn league_id ->
            handle_create_task(league_id, today, next_week)
          end)
          |> Enum.map(&Task.await/1)
          |> Enum.map(fn
            {:ok, %{"response" => fixtures}} -> fixtures
            {:error, _} -> []
          end)

        send(self(), {:leagues_loaded, results})
        {:noreply, socket}

      {:error, _} ->
        {:noreply, assign(socket, loading_leagues: false)}
    end
  end

  defp handle_create_task(league_id, today, next_week) do
    Task.async(fn -> SportsAPI.get_leagues_matches(league_id, today, next_week) end)
  end

  def handle_info({:country_loaded, country}, socket) do
    {:noreply, assign(socket, loading_country: false, country: country)}
  end

  def handle_info({:leagues_loaded, leagues}, socket) do
    {:noreply, assign(socket, loading_leagues: false, leagues: leagues)}
  end
end
