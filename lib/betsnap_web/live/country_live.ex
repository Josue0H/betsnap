defmodule BetsnapWeb.CountryLive do
  use BetsnapWeb, :live_view

  alias BetsnapWeb.Api.SportsAPI

  def mount(_params, _session, socket) do
    {:ok, assign(socket, leagues: [])}
  end

  def handle_params(%{"code" => code}, _uri, socket) do

    {:ok, %{ "response" => country }} = SportsAPI.get_country(code)

    {:ok, %{ "response" => leagues }} = SportsAPI.get_country_leagues(code)

    ids = Enum.map(leagues, fn league -> league["league"]["id"] end)

    country = Enum.at(country, 0)

    socket = assign(
      socket,
      leagues: ids,
      country: country
    )

    IO.inspect(country)

    {:noreply, socket}
  end


end
