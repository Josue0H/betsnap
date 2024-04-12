defmodule BetsnapWeb.Live.MyBetsTest do
  use BetsnapWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Betsnap.AccountsFixtures

  test "Redirect if user is not logged in", %{conn: conn} do
    assert {:error, redirect} = live(conn, ~p"/my-bets")

    assert {:redirect, %{to: path, flash: flash}} = redirect
    assert path == ~p"/users/log_in"
    assert %{"error" => "You must log in to access this page."} = flash
  end

  test "Render my bets page", %{conn: conn} do
    {:ok, _live, html} =
      conn
      |> log_in_user(user_fixture())
      |> live(~p"/my-bets")

    assert html =~ "My Bets"
  end
end
