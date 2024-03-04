defmodule BetsnapWeb.MatchLive do
  use BetsnapWeb, :live_view

  alias BetsnapWeb.Api.SportsAPI
  alias Betsnap.Bet

  import Number.Currency

  def mount(_params, _session, socket) do
    socket = assign(socket, match: nil)

    {:ok, socket}
  end

  def handle_params(%{ "id" => id, "odd" => odd, "value" => value, "bet" => bet }, _uri, socket) do
    {:ok, %{"response" => match}} = SportsAPI.get_match(id)

    match =
      match
      |> Enum.at(0)

    active_tab = if match["fixture"]["status"]["short"] == "NS" do
      :bets
    else
      :standings
    end

    socket = assign(
      socket,
      match: match,
      active_tab: active_tab,
      odd: odd,
      value: value,
      show_modal: true,
      bet: bet,
      stake: "")

    {:noreply, socket}
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

    active_tab = if match["fixture"]["status"]["short"] == "NS" do
      :bets
    else
      :standings
    end

    socket = assign(socket, match: match, active_tab: active_tab, show_modal: false)

    {:noreply, socket}
  end

  def handle_params(_, _uri, socket) do
    {:noreply, redirect(socket, to: "/")}
  end

  def handle_event("new_stake", %{"stake" => stake}, socket) do
    {:noreply, assign(socket, stake: stake)}
  end

  def handle_event("new_bet", params, socket) do

    if !socket.assigns.current_user do
      {:noreply, redirect(socket, to: "/")}
    end

    if params["stake"] == "" || params["stake"] == 0 do
      {:noreply, socket |> put_flash(:error, "Stake cannot be empty") |> redirect(to: "/match?id=#{params["fixture_id"]}") }
    end

    if Decimal.compare(params["stake"], socket.assigns.current_user.balance) == :gt do
      IO.puts "Insufficient balance"
      {:noreply, socket |> put_flash(:error, "Insufficient balance") |> redirect(to: "/match?id=#{params["fixture_id"]}") }
    else
      params = Map.merge(params, %{"user_id" => Integer.to_string(socket.assigns.current_user.id), "earn" => Decimal.mult(params["odd"], params["stake"]), "status" => "pending"})

      case Bet.create_bet(params) do
        {:ok, _} ->
          socket =
            socket
            |> put_flash(:info, "Bet placed successfully")
            |> redirect(to: "/match?id=#{params["fixture_id"]}")

          {:noreply, socket}
        {:error, message} ->
          {:noreply, socket |> put_flash(:error, message) |> redirect(to: "/match?id=#{params["fixture_id"]}")}
      end
    end

  end



  def get_date(timestamp) do
    datetime = DateTime.from_unix!(timestamp)

    date = Timex.format!(datetime, "{ISO:Extended}")

    [date, time] = String.split(date, "T")

    time = String.split(time, ":")

    date <> " @ " <> Enum.at(time, 0) <> ":" <> Enum.at(time, 1)
  end


end
