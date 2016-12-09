defmodule MetaDashboard.PageControllerTest do
  use MetaDashboard.ConnCase

  import Mock

  test "GET /", %{conn: conn} do
    with_mock Heroku.Addon, [list_existing_addons_for_an_app: fn(app) -> {:ok, [%{"name" => "#{app}-addon-one"}, %{"name" => "#{app}-addon-two"}]} end] do
      conn = get conn, "/"

      assert html_response(conn, 200) =~ "travis-production"
      assert html_response(conn, 200) =~ "travis-production-addon-one"
      assert html_response(conn, 200) =~ "travis-production-addon-two"

      assert html_response(conn, 200) =~ "travis-pro-production"
      assert html_response(conn, 200) =~ "travis-pro-production-addon-one"
      assert html_response(conn, 200) =~ "travis-pro-production-addon-two"
    end
  end

  test "GET /app/addon-name", %{conn: conn} do
    with_mock Heroku.Addon, [list_existing_addons_for_an_app: fn(app) -> {:ok, [%{"name" => "addon-name", "sso_url" => "http://example.com"}, %{"name" => "another"}]} end] do
      conn = get conn, "/app/addon-name"

      assert redirected_to(conn) == "http://example.com"
    end
  end
end
