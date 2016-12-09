defmodule MetaDashboard.DashboardControllerTest do
  use MetaDashboard.ConnCase

  import Mock

  test "GET /app/addon-name", %{conn: conn} do
    with_mock Heroku.Addon, [list_existing_addons_for_an_app: fn(app) -> {:ok, [%{"name" => "addon-name", "sso_url" => "http://example.com"}, %{"name" => "another"}]} end] do
      conn = get conn, "/app/addon-name"

      assert redirected_to(conn) == "http://example.com"
    end
  end
end
