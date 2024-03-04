defmodule BetsnapWeb.MyBetsLive do
  use BetsnapWeb, :live_view

  alias Betsnap.Bet

  import Number.Currency


  def mount(_params, _session, socket) do
    bets = Bet.get_bets(socket.assigns.current_user.id)

    socket = assign(
      socket,
      bets: bets
    )
    {:ok, socket}
  end

  def bet(assigns) do
    ~H"""
    <div class="bg-brand w-full p-5 rounded-md my-2 relative flex justify-between" >
      <div>
        <div class="flex">
          <h6 class="text-white text-3xl"><%= assigns.bet.value %></h6>
          <h6 class="mx-2 text-white font-bold text-3xl"><%= assigns.bet.odd %></h6>
        </div>
        <p class="text-white text-xs my-1"><%= assigns.bet.info.name %></p>
        <p class="text-white text-xs my-1"><%= get_date(assigns.bet.info.timestamp) %></p>
      </div>
      <div>
        <h6 class="text-white text-xs">Bet: <%= number_to_currency(assigns.bet.stake) %></h6>
        <h6 class="text-white text-xs">Earnings: <%= number_to_currency(assigns.bet.earn) %></h6>
        <p class="text-white text-xs font-bold"><%= assigns.bet.info.result %></p>
        <%= if assigns.bet.status == "win" do %>
          <div class="absolute bottom-0 right-0 bg-green-500 text-white p-1 rounded-md">
            <p>Win</p>
          </div>
        <% end %>
        <%= if assigns.bet.status == "loss" do %>
          <div class="absolute bottom-0 right-0 bg-red-500 text-white p-1 rounded-md">
            <p>Loss</p>
          </div>
        <% end %>
        <%= if assigns.bet.status == "pending" || is_live?(assigns.bet.info.timestamp) do %>
          <.button
            class="bg-dark text-white p-1 rounded-md mt-3"
            phx-click="close_bet"
            phx-value-id={assigns.bet.id}
          >Close Bet</.button>
        <% end %>
      </div>
    </div>
    """
  end

  def is_live?(timestamp) do
    DateTime.utc_now() |> DateTime.to_unix() < timestamp
  end

  def get_date(timestamp) do
    datetime = DateTime.from_unix!(timestamp)

    date = Timex.format!(datetime, "{ISO:Extended}")

    [date, time] = String.split(date, "T")

    time = String.split(time, ":")

    date <> " @ " <> Enum.at(time, 0) <> ":" <> Enum.at(time, 1)
  end

  def handle_event("close_bet", %{"id" => id}, socket) do

    case Bet.delete_bet(id) do
      {:ok, _} -> {:noreply, socket |> put_flash(:info, "Bet closed successfully.") |> assign(bets: Bet.get_bets(socket.assigns.current_user.id)) |> redirect(to: "/my-bets")}
      {:error, _} -> {:noreply, socket |> put_flash(:error, "Bet could not be closed.")}
      _ -> {:noreply, socket |> put_flash(:error, "Bet could not be closed.")}
    end

  end

end
