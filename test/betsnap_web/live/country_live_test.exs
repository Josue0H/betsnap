defmodule BetsnapWeb.Live.CountryLiveTest do
  use BetsnapWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "Render country page", %{conn: conn} do
    conn = get(conn, ~p"/country?code=AL")
    assert html_response(conn, 200) =~ "Leagues"
  end

  test "Load country", %{conn: conn} do
    {:ok, live, html} =
      conn
      |> live(~p"/country?code=AL")

    :timer.sleep(3000)
    html = render(live)

    assert html =~ "Albania"
  end

  test "Load country leagues", %{conn: conn} do
    {:ok, live, html} =
      conn
      |> live(~p"/country?code=AL")

    :timer.sleep(6000)
    html = render(live)

    assert html =~ "Liga MX"
    assert html =~ "Estadio Corregidora"
    assert html =~ "Estadio Victoria"
  end
end
