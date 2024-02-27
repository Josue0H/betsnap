defmodule BetsnapWeb.MatchLive do
  use BetsnapWeb, :live_view

  alias BetsnapWeb.Api.SportsAPI

  def mount(socket) do
    {:ok, socket}
  end

  def handle_params(%{ "id" => id }, _uri, socket) do

    {:ok, %{"response" => match}} = SportsAPI.get_match(id)

    match =
      match
      |> Enum.at(0)

    socket = assign(socket, match: match)

    {:noreply, socket}
  end

  def handle_params(_, _uri, socket) do

    # if there are no params, redirect to home
    {:noreply, redirect(socket, to: "/")}

    {:noreply, socket}
  end

  def get_date(timestamp) do
    datetime = DateTime.from_unix!(timestamp)

    date = Timex.format!(datetime, "{ISO:Extended}")

    [date, time] = String.split(date, "T")

    time = String.split(time, ":")

    date <> " @ " <> Enum.at(time, 0) <> ":" <> Enum.at(time, 1)
  end


end
