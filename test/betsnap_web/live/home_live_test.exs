defmodule BetsnapWeb.Live.HomeLiveTest do
  use BetsnapWeb.ConnCase, async: true

  test "Render home page", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Best betting site"
  end
end
