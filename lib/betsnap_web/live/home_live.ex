defmodule BetsnapWeb.HomeLive do
  use BetsnapWeb, :live_view

  alias Betsnap.HomeServer

  def mount(_params, _session, socket) do
    if connected?(socket) do
      HomeServer.subscribe()
    end

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

    home_data = HomeServer.get_home_data()

    socket =
      assign(
        socket,
        countries: home_data.countries,
        leagues: home_data.leagues,
        value: 0,
        elements: elements
      )

    {:ok, socket}

  end

  # def handle_info({:countries_loaded, countries}, socket) do
  #   {:noreply, assign(socket, loading_countries: false, countries: countries)}
  # end

  # def handle_info({:leagues_loaded, leagues}, socket) do
  #   {:noreply, assign(socket, loading_leagues: false, leagues: leagues)}
  # end

  def handle_info(:next_slide, socket) do
    value = rem(socket.assigns.value + 1, length(socket.assigns.elements))

    {:noreply, assign(socket, :value, value)}
  end

  def handle_info({:receive_data, data}, socket) do
    IO.inspect "Received data"

    socket =
      assign(
        socket,
        countries: data.countries,
        leagues: data.leagues,
      )

    {:noreply, socket}
  end
end
