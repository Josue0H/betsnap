defmodule Betsnap.HomeServer do
  use GenServer

  alias BetsnapWeb.Services.SportsAPI

  @name :home_server

  @interval :timer.minutes(10)
  # @interval :timer.seconds(5)

  @premier_league_id 39
  @liga_mx_id 262
  @bundesliga_id 78
  @la_liga_id 140
  @serie_a_id 135
  @champions_league 2

  defmodule State do
    defstruct countries: [], leagues: []
  end


  # PubSub

  def subscribe do
    Phoenix.PubSub.subscribe(Betsnap.PubSub, "home")
  end

  def broadcast({:ok, content}, tag) do
    Phoenix.PubSub.broadcast(Betsnap.PubSub, "home", {tag, content})
  end

  def broadcast({:error, _} = error, _tag), do: error

  def start_link(_args) do
    IO.puts("Starting HomeServer...")
    GenServer.start_link(__MODULE__, %State{}, name: @name)
  end


  def get_home_data do
    GenServer.call @name, :get_data
  end


  def init(_state) do
    {:ok, new_state} = get_data()

    broadcast({:ok, new_state}, :receive_data)
    schedule_update()
    {:ok, new_state}
  end

  def handle_call(:get_data, _from, state) do
    {:reply, state, state}
  end

  defp schedule_update do
    Process.send_after(self(), :update, @interval)
  end

  def handle_info(:update, _state) do
    IO.puts("Updating HomeServer...")
    {:ok, new_state} = get_data()

    broadcast({:ok, new_state}, :receive_data)
    schedule_update()
    {:noreply, new_state}
  end

  defp get_data do
    countries = case SportsAPI.get_countries() do
      {:ok, response} ->
        %{"response" => countries} = response
        countries

      {:error, _} ->
        []
    end

    today = Date.utc_today()
    next_week = Date.add(today, 7)

    best_leagues = [@liga_mx_id, @premier_league_id, @bundesliga_id, @la_liga_id, @serie_a_id, @champions_league]

    leagues =
      Enum.map(best_leagues, fn league_id ->
        case SportsAPI.get_leagues_matches(league_id, today, next_week) do
          {:ok, response} ->
            %{"response" => fixtures} = response
            fixtures

          {:error, _} ->
            []
        end
      end)

    # IO.inspect(countries, label: "Countries")
    # IO.inspect(leagues, label: "Leagues")

    {:ok, %State{ countries: countries, leagues: leagues }}
  end

end
