defmodule BetsnapWeb.MatchTabs do
  @moduledoc """
  Module to handle match tabs
  """

  use BetsnapWeb, :live_component

  alias BetsnapWeb.Services.SportsAPI

  @last_matches 5

  def mount(socket) do
    socket =
      assign(
        socket,
        active_tab: :bets,
        match: nil,
        odds: [],
        standings: [],
        players: %{},
        matches: %{}
      )

    {:ok, socket}
  end

  def update(assigns, socket) do
    odds_task = Task.async(fn -> SportsAPI.get_odds(assigns.match["fixture"]["id"]) end)

    standings_task =
      Task.async(fn ->
        SportsAPI.get_standings(assigns.match["league"]["season"], assigns.match["league"]["id"])
      end)

    players_home_task =
      Task.async(fn -> SportsAPI.get_players(assigns.match["teams"]["home"]["id"]) end)

    players_away_task =
      Task.async(fn -> SportsAPI.get_players(assigns.match["teams"]["away"]["id"]) end)

    matches_home_task =
      Task.async(fn ->
        SportsAPI.get_past_fixtures(assigns.match["teams"]["home"]["id"], @last_matches)
      end)

    matches_away_task =
      Task.async(fn ->
        SportsAPI.get_past_fixtures(assigns.match["teams"]["away"]["id"], @last_matches)
      end)

    {:ok, odds_response} = Task.await(odds_task)
    {:ok, standings_response} = Task.await(standings_task)
    {:ok, players_home_response} = Task.await(players_home_task)
    {:ok, players_away_response} = Task.await(players_away_task)
    {:ok, matches_home_response} = Task.await(matches_home_task)
    {:ok, matches_away_response} = Task.await(matches_away_task)

    odds =
      odds_response
      |> Map.get("response", [])
      |> List.first()
      |> Map.get("bookmakers", [])
      |> List.first()
      |> Map.get("bets", [])

    standings =
      standings_response
      |> Map.get("response", [])
      |> List.first()
      |> Map.get("league", [])
      |> Map.get("standings", [])
      |> List.first()
      |> Enum.sort_by(& &1["rank"])

    players = %{
      home: players_home_response |> Map.get("response", []),
      away: players_away_response |> Map.get("response", [])
    }

    matches = %{
      home: matches_home_response |> Map.get("response", []),
      away: matches_away_response |> Map.get("response", [])
    }

    socket =
      assign(socket,
        odds: odds,
        standings: standings,
        players: players,
        matches: matches,
        active_tab: assigns.active_tab,
        match: assigns.match
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="w-full">
      <div class={
        if (@match["fixture"]["status"]["short"] === "NS" ||
              @match["fixture"]["status"]["short"] == "PST") && @odds != [],
           do: "grid grid-cols-4 mt-3",
           else: "grid grid-cols-3 mt-3"
      }>
        <%= if (@match["fixture"]["status"]["short"] === "NS" || @match["fixture"]["status"]["short"] == "PST") && @odds != [] do %>
          <.link
            patch={"/match?id=#{@match["fixture"]["id"]}&tab=bets"}
            class={
              if @active_tab === :bets,
                do: "cursor-pointer w-full bg-white flex justify-center items-center text-brand",
                else:
                  "cursor-pointer w-full bg-brand flex justify-center items-center text-white hover:bg-white hover:text-brand py-2 transition-all"
            }
          >
            Bets
          </.link>
        <% end %>

        <.link
          patch={"/match?id=#{@match["fixture"]["id"]}&tab=standings"}
          class={
            if @active_tab === :standings,
              do: "cursor-pointer w-full bg-white flex justify-center items-center text-brand",
              else:
                "cursor-pointer w-full bg-brand flex justify-center items-center text-white hover:bg-white hover:text-brand py-2 transition-all"
          }
        >
          Standings
        </.link>

        <.link
          patch={"/match?id=#{@match["fixture"]["id"]}&tab=players"}
          class={
            if @active_tab === :players,
              do: "cursor-pointer w-full bg-white flex justify-center items-center text-brand",
              else:
                "cursor-pointer w-full bg-brand flex justify-center items-center text-white hover:bg-white hover:text-brand py-2 transition-all"
          }
        >
          Players
        </.link>

        <.link
          patch={"/match?id=#{@match["fixture"]["id"]}&tab=matches"}
          class={
            if @active_tab === :matches,
              do: "cursor-pointer w-full bg-white flex justify-center items-center text-brand",
              else:
                "cursor-pointer w-full bg-brand flex justify-center items-center text-white hover:bg-white hover:text-brand py-2 transition-all"
          }
        >
          Matches
        </.link>
      </div>

      <div class="pb-5">
        <%= if @active_tab === :bets do %>
          <.bets odds={@odds} match={@match} />
        <% end %>

        <%= if @active_tab === :standings do %>
          <.standings standings={@standings} match={@match} />
        <% end %>

        <%= if @active_tab === :players do %>
          <.players players={@players} />
        <% end %>

        <%= if @active_tab === :matches do %>
          <.matches matches={@matches} />
        <% end %>
      </div>
    </div>
    """
  end

  def bets(assigns) do
    ~H"""
    <div class="w-full flex flex-col justify-center p-5">
      <%= for odd <- Enum.slice(assigns.odds, 0..11) do %>
        <.odd odd={odd} match={assigns.match} />
      <% end %>
    </div>
    """
  end

  def odd(assigns) do
    ~H"""
    <div>
      <hr class="text-white w-full my-2" />
      <h1 class="text-white text-bold"><%= assigns.odd["name"] %></h1>

      <div class="grid grid-cols-6 mt-2">
        <%= for bet <- assigns.odd["values"] do %>
          <.link
            href={"/match/new_bet?id=#{assigns.match["fixture"]["id"]}&odd=#{bet["odd"]}&value=#{bet["value"]}&bet=#{assigns.odd["id"]}"}
            class="flex flex-col justify-center items-center p-2 bg-dark cursor-pointer border-[1px] border-brand hover:bg-brand transition-all"
          >
            <span class="text-white"><%= bet["value"] %></span>
            <span class="text-white"><%= bet["odd"] %></span>
          </.link>
        <% end %>
      </div>
    </div>
    """
  end

  def standings(assigns) do
    ~H"""
    <div class="w-full mt-5">
      <table class="w-full table-auto bg-brand">
        <thead class="text-white bg-dark">
          <tr>
            <th class="px-4 py-2">#</th>

            <th class="px-4 py-2">Team</th>

            <th class="px-4 py-2">P</th>

            <th class="px-4 py-2">DIFF</th>

            <th class="px-4 py-2">PTS</th>
          </tr>
        </thead>

        <tbody>
          <%= for standing <- assigns.standings do %>
            <tr class={
              if standing["team"]["id"] === assigns.match["teams"]["home"]["id"] ||
                   standing["team"]["id"] === assigns.match["teams"]["away"]["id"] do
                "bg-white text-brand"
              else
                "text-white"
              end
            }>
              <td class="px-4 py-2 text-center"><%= standing["rank"] %></td>

              <td class="px-4 py-2 flex items-center">
                <img src={standing["team"]["logo"]} alt={standing["team"]["name"]} class="w-8 h-8" />
                <span class="ml-2"><%= standing["team"]["name"] %></span>
              </td>

              <td class="px-4 py-2 text-center"><%= standing["all"]["played"] %></td>

              <td class="px-4 py-2 text-center"><%= standing["goalsDiff"] %></td>

              <td class="px-4 py-2 text-center"><%= standing["points"] %></td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end

  def players(assigns) do
    ~H"""
    <div class="w-full mt-5 flex">
      <div class="w-1/2">
        <h1 class="text-white text-3xl">Home Players</h1>

        <table class="w-full table-auto bg-brand mt-3">
          <tbody>
            <%= for player <- assigns.players.home do %>
              <tr class="text-white">
                <td class="px-4 py-2 flex items-center relative">
                  <img
                    class="rounded-full w-8 h-8"
                    src={player["player"]["photo"]}
                    alt={player["player"]["name"]}
                    class="w-8 h-8"
                  /> <span class="ml-2"><%= player["player"]["name"] %></span>
                  <%= if player["injured"] do %>
                    <.icon name="hero-plus-circle" class="absolute text-white top-0 right-0 m-3" />
                  <% end %>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>

      <div class="w-1/2">
        <h1 class="text-white text-3xl">Away Players</h1>

        <table class="w-full table-auto bg-white mt-3">
          <tbody>
            <%= for player <- assigns.players.away do %>
              <tr class="text-brand">
                <td class="px-4 py-2 flex items-center relative">
                  <img
                    class="rounded-full w-8 h-8"
                    src={player["player"]["photo"]}
                    alt={player["player"]["name"]}
                    class="w-8 h-8"
                  /> <span class="ml-2"><%= player["player"]["name"] %></span>
                  <%= if player["injured"] do %>
                    <.icon name="hero-plus-circle" class="absolute text-brand top-0 right-0 m-3" />
                  <% end %>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    </div>
    """
  end

  def matches(assigns) do
    ~H"""
    <div class="w-full mt-5 flex">
      <div class="w-1/2">
        <h1 class="text-white text-3xl">Home</h1>

        <table class="w-full table-auto bg-brand mt-3">
          <tbody>
            <%= for match <- assigns.matches.home do %>
              <tr class="text-white border-b-[1px] border-white">
                <td class="px-4 py-2 flex flex-col">
                  <div class="w-full flex justify-between mb-2">
                    <div class="flex items-center">
                      <img
                        class="w-8 h-8 mr-3"
                        src={match["teams"]["home"]["logo"]}
                        alt={match["teams"]["home"]["name"]}
                      />
                      <span class={
                        if match["teams"]["home"]["winner"] do
                          "text-white font-bold"
                        else
                          "text-white"
                        end
                      }>
                        <%= match["teams"]["home"]["name"] %>
                      </span>
                    </div>

                    <span class={
                      if match["teams"]["home"]["winner"] do
                        "text-white font-bold"
                      else
                        "text-white"
                      end
                    }>
                      <%= match["goals"]["home"] %>
                    </span>
                  </div>

                  <div class="w-full flex justify-between">
                    <div class="flex items-center">
                      <img
                        class="w-8 h-8 mr-3"
                        src={match["teams"]["away"]["logo"]}
                        alt={match["teams"]["away"]["name"]}
                      />
                      <span class={
                        if match["teams"]["away"]["winner"] do
                          "text-white font-bold"
                        else
                          "text-white"
                        end
                      }>
                        <%= match["teams"]["away"]["name"] %>
                      </span>
                    </div>

                    <span class={
                      if match["teams"]["away"]["winner"] do
                        "text-white font-bold"
                      else
                        "text-white"
                      end
                    }>
                      <%= match["goals"]["away"] %>
                    </span>
                  </div>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>

      <div class="w-1/2">
        <h1 class="text-white text-3xl">Away</h1>

        <table class="w-full table-auto bg-white mt-3">
          <tbody>
            <%= for match <- assigns.matches.away do %>
              <tr class="text-brand border-b-[1px] border-brand">
                <td class="px-4 py-2 flex flex-col">
                  <div class="w-full flex justify-between mb-2">
                    <div class="flex items-center">
                      <img
                        class="w-8 h-8 mr-3"
                        src={match["teams"]["home"]["logo"]}
                        alt={match["teams"]["home"]["name"]}
                      />
                      <span class={
                        if match["teams"]["home"]["winner"] do
                          "text-brand font-bold"
                        else
                          "text-brand"
                        end
                      }>
                        <%= match["teams"]["home"]["name"] %>
                      </span>
                    </div>

                    <span class={
                      if match["teams"]["home"]["winner"] do
                        "text-brand font-bold"
                      else
                        "text-brand"
                      end
                    }>
                      <%= match["goals"]["home"] %>
                    </span>
                  </div>

                  <div class="w-full flex justify-between">
                    <div class="flex items-center">
                      <img
                        class="w-8 h-8 mr-3"
                        src={match["teams"]["away"]["logo"]}
                        alt={match["teams"]["away"]["name"]}
                      />
                      <span class={
                        if match["teams"]["away"]["winner"] do
                          "text-brand font-bold"
                        else
                          "text-brand"
                        end
                      }>
                        <%= match["teams"]["away"]["name"] %>
                      </span>
                    </div>

                    <span class={
                      if match["teams"]["away"]["winner"] do
                        "text-brand font-bold"
                      else
                        "text-brand"
                      end
                    }>
                      <%= match["goals"]["away"] %>
                    </span>
                  </div>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    </div>
    """
  end
end
