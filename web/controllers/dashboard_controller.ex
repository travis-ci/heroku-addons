defmodule MetaDashboard.DashboardController do
  use MetaDashboard.Web, :controller

  def index(conn, _params) do
    apps = Enum.map(~w{travis-production travis-pro-production}, fn(app) ->
      {_, addons} = Heroku.Addon.list_existing_addons_for_an_app(app)

      %{
        :name => app,
        :addons => Enum.map(addons, fn(addon) ->
          %{
            :name => addon["name"],
            :url => addon["sso_url"]
          }
        end)
      }
    end)

    render conn, "index.html", apps: apps
  end

  def addon(conn, %{"app" => app, "addon" => addon_name}) do
    {_, addons} = Heroku.Addon.list_existing_addons_for_an_app(app)
    [url] = Enum.filter_map(addons, fn(addon) -> addon["name"] == addon_name end, &(&1["sso_url"]))
    redirect(conn, external: url)
  end
end
