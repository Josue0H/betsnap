defmodule BetsnapWeb.HomeLive do
  use BetsnapWeb, :live_view

  alias BetsnapWeb.Api.SportsAPI

  @premier_league_id 39
  @liga_mx_id 262
  @bundesliga_id 78
  @la_liga_id 140
  @serie_a_id 135

  def mount(_params, _session, socket) do

    {:ok, %{ "response" => countries }} = SportsAPI.get_countries()

    socket = assign(
      socket,
      countries: countries,
      best_leagues: [@liga_mx_id, @premier_league_id, @bundesliga_id, @la_liga_id, @serie_a_id]
    )

    {:ok, socket}
  end



end
