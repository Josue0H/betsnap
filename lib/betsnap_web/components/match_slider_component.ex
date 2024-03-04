defmodule BetsnapWeb.MatchSlider do
  use BetsnapWeb, :live_component

  alias BetsnapWeb.Api.SportsAPI

  def mount(socket) do

    {:ok, socket}
  end

  def update(assigns, socket) do
    today = Date.utc_today()
    next_week = Date.add(today, 7)

    {:ok, %{"response" => matches}} = SportsAPI.get_leagues_matches(assigns.id, today, next_week)



    socket = assign(socket, matches: matches)

    {:ok, socket}
  end


  def render(assigns) do
    ~H"""
    <div>
      <%= if length(@matches) > 0 do %>
        <div class="w-full h-1/2 relative py-2 px-2">
          <hr class="border-white my-2"/>
          <h1 class="text-white"><%= Enum.at(@matches, 0)["league"]["name"]%></h1>
          <div class="w-full flex overflow-auto custom-slider">
            <%= for match <- @matches do %>
              <.match_card match={match} />
            <% end %>
          </div>
        </div>
      <% else %>
        <div class="w-full h-1/2 relative py-2 px-2">
          <hr class="border-white my-2"/>
          <h1 class="text-white"><%= Enum.at(@matches, 0)["league"]["name"]%></h1>
          <h1 class="text-white">No matches found</h1>
        </div>
      <% end %>
    </div>
    """
  end

  def match_card(assigns) do
   ~H"""
    <.link
      href={"/match?id=#{@match["fixture"]["id"]}"}
      class="cursor-pointer bg-brand pt-5 pb-3  px-3 m-2 min-w-64 min-h-40 rounded hover:scale-105 transition-all"
    >
      <div class="flex flex-col justify-center items-center">
        <span class="text-white text-center"><%= get_date(@match["fixture"]["timestamp"]) %></span>
        <span class="text-white text-xs text-center"><%= @match["fixture"]["venue"]["name"] %></span>
      </div>
      <div class="flex w-full h-auto mt-5 justify-around items-center">
        <%= if @match["teams"]["home"]["logo"] do %>
          <img src={@match["teams"]["home"]["logo"]} alt={@match["teams"]["home"]["name"]} class="w-12 h-12"/>
        <% else %>
          <span class="text-white font-bold"><%= @match["teams"]["home"]["name"] %></span>
        <% end %>
        <span class="text-white font-bold">vs</span>
        <%= if @match["teams"]["away"]["logo"] do %>
          <img src={@match["teams"]["away"]["logo"]} alt={@match["teams"]["away"]["name"]} class="w-12 h-12"/>
        <% else %>
          <span class="text-white font-bold"><%= @match["teams"]["away"]["name"] %></span>
        <% end %>
      </div>
      <div class="w-full flex justify-center items-center">
        <%= if @match["fixture"]["status"]["short"] === "FT" do %>
          <span class="text-white text-center">FT <%= @match["goals"]["home"] %> - <%= @match["goals"]["away"] %></span>
        <% end %>
        <%= if @match["fixture"]["status"]["short"] != "FT" && @match["fixture"]["status"]["short"] != "NS" do %>
          <div class="h-2 w-2 bg-[green] mx-1 rounded"></div>
          <span class="text-white text-center">LIVE</span>
        <% end %>
      </div>
    </.link>
    """
  end

  def get_date(timestamp) do
    datetime = DateTime.from_unix!(timestamp)

    date = Timex.format!(datetime, "{ISO:Extended}")

    [date, time] = String.split(date, "T")

    time = String.split(time, ":")

    date <> " @ " <> Enum.at(time, 0) <> ":" <> Enum.at(time, 1)
  end
end
