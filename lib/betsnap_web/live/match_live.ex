defmodule BetsnapWeb.MatchLive do
  use BetsnapWeb, :live_view

  alias BetsnapWeb.Services.SportsAPI
  alias Betsnap.Bets

  import Number.Currency

  def mount(_params, _session, socket) do
    socket = assign(socket, match: nil, loading_match: true, active_tab: :bets, show_modal: nil)

    {:ok, socket}
  end

  def load_match(id, socket) do
    with {:ok, %{"response" => match}} <- SportsAPI.get_match(id) do
      match =
        match
        |> Enum.at(0)

      send(self(), {:match_loaded, match})
      match["fixture"]["status"]["short"]
    else
      {:error, _} ->
        {:noreply, redirect(socket, to: "/")}
    end
  end

  def handle_params(%{"id" => id, "odd" => odd, "value" => value, "bet" => bet}, _uri, socket) do
    load_match(id, socket)


    socket =
      assign(
        socket,
        match: nil,
        loading_match: true,
        active_tab: :standings,
        odd: odd,
        value: value,
        show_modal: true,
        bet: bet,
        stake: ""
      )

    {:noreply, socket}
  end

  def handle_params(%{"id" => id, "tab" => tab}, _uri, socket) do
    load_match(id, socket)

    socket = assign(socket, match: nil, loading_match: true, active_tab: String.to_atom(tab))

    {:noreply, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    load_match(id, socket)

    socket =
      assign(socket, match: nil, loading_match: true, active_tab: :standings, show_modal: false)

    {:noreply, socket}
  end

  def handle_params(_, _uri, socket) do
    {:noreply, redirect(socket, to: "/")}
  end

  def handle_info({:match_loaded, match}, socket) do
    {:noreply, assign(socket, match: match, loading_match: false)}
  end

  def handle_event("new_stake", %{"stake" => stake}, socket) do
    {:noreply, assign(socket, stake: stake)}
  end

  def handle_event("new_bet", params, socket) do
    if !socket.assigns.current_user do
      {:noreply, redirect(socket, to: "/")}
    end

    if params["stake"] == "" || params["stake"] == 0 do
      {:noreply,
       socket
       |> put_flash(:error, "Stake cannot be empty")
       |> redirect(to: "/match?id=#{params["fixture_id"]}")}
    end

    if Decimal.compare(params["stake"], socket.assigns.current_user.balance) == :gt do
      IO.puts("Insufficient balance")

      {:noreply,
       socket
       |> put_flash(:error, "Insufficient balance")
       |> redirect(to: "/match?id=#{params["fixture_id"]}")}
    else
      params =
        Map.merge(params, %{
          "user_id" => Integer.to_string(socket.assigns.current_user.id),
          "earn" => Decimal.mult(params["odd"], params["stake"]),
          "status" => "pending"
        })

      case Bets.create_bet(params) do
        {:ok, _} ->
          socket =
            socket
            |> put_flash(:info, "Bet placed successfully")
            |> redirect(to: "/match?id=#{params["fixture_id"]}")

          {:noreply, socket}

        {:error, message} ->
          {:noreply,
           socket
           |> put_flash(:error, message)
           |> redirect(to: "/match?id=#{params["fixture_id"]}")}
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
