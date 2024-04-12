defmodule BetsnapWeb.Live.MatchLiveTest do
  use BetsnapWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "Render match page", %{conn: conn} do
    conn = get(conn, ~p"/match?id=1150338")
    assert html_response(conn, 200) =~ "Loading..."
  end

  test "Load match", %{conn: conn} do
    {:ok, live, html} =
      conn
      |> live(~p"/match?id=1150338")

    :timer.sleep(3000)
    html = render(live)

    assert html =~ "Guadalajara Chivas"
    assert html =~ "Pachuca"
    assert html =~ "Estadio Hidalgo, Pachuca de Soto"
    assert html =~ "Liga MX - Clausura - 15"
  end

  test "Load match tabs", %{conn: conn} do
    {:ok, live, html} =
      conn
      |> live(~p"/match?id=1150338")

    :timer.sleep(3000)
    html = render(live)

    assert html =~ "Standings"
    assert html =~ "Players"
    assert html =~ "Matches"
    assert html =~ "Bets"
  end
end
