defmodule MetaDashboard.PageController do
  use MetaDashboard.Web, :controller

  def index(conn, _params) do
    apps = Enum.map(~w{travis-production travis-pro-production}, fn(app) ->
      {_, addons} = Heroku.Addon.list_existing_addons_for_an_app(app)

      %{
        :name => app,
        :addons => Enum.map(addons, fn(addon) ->
          %{:name => addon["name"]}
        end)
      }
    end)

    render conn, "index.html", apps: apps
  end
end
