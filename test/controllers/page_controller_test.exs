defmodule MetaDashboard.PageControllerTest do
  use MetaDashboard.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "travis-production"
    assert html_response(conn, 200) =~ "travis-pro-production"
  end
end
