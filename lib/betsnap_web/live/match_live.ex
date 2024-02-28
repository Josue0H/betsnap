defmodule BetsnapWeb.MatchLive do
  use BetsnapWeb, :live_view

  alias BetsnapWeb.Api.SportsAPI

  def mount(_params, _session, socket) do
    socket = assign(socket, match: nil)

    {:ok, socket}
  end

  def handle_params(%{ "id" => id, "tab" => tab }, _uri, socket) do

    {:ok, %{"response" => match}} = SportsAPI.get_match(id)

    match =
      match
      |> Enum.at(0)

    socket = assign(socket, match: match, active_tab: String.to_atom(tab))

    {:noreply, socket}
  end

  def handle_params(%{ "id" => id }, _uri, socket) do

    {:ok, %{"response" => match}} = SportsAPI.get_match(id)

    match =
      match
      |> Enum.at(0)

    socket = assign(socket, match: match, active_tab: :bets)

    {:noreply, socket}
  end

  def handle_params(_, _uri, socket) do
    {:noreply, redirect(socket, to: "/")}
  end


  def get_date(timestamp) do
    datetime = DateTime.from_unix!(timestamp)

    date = Timex.format!(datetime, "{ISO:Extended}")

    [date, time] = String.split(date, "T")

    time = String.split(time, ":")

    date <> " @ " <> Enum.at(time, 0) <> ":" <> Enum.at(time, 1)
  end


end
