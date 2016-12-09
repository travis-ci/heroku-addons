defmodule HerokuAddons.DashboardControllerTest do
  use HerokuAddons.ConnCase

  import Mock

  test "GET /app/addon-name", %{conn: conn} do
    with_mock Heroku.Addon, [list_existing_addons_for_an_app: fn(_) -> {:ok, [%{"name" => "addon-name", "sso_url" => "http://example.com"}, %{"name" => "another"}]} end] do
      conn = get conn, "/app/addon-name"

      assert redirected_to(conn) == "http://example.com"
    end
  end
end
