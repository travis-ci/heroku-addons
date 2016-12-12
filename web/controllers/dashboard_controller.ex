defmodule HerokuAddons.DashboardController do
  use HerokuAddons.Web, :controller

  def index(conn, _params) do
    apps = Enum.map(Application.get_env(:heroku_addons, :heroku_apps), fn(app) ->
      {_, addons} = Heroku.Addon.list_existing_addons_for_an_app(app)

      %{
        :name => app,
        :groups => Enum.map(Enum.group_by(addons, &(&1["group_description"])), fn {group, addons} ->
          %{
            :name => group,
            :addons => Enum.map(addons, fn(addon) ->
              %{
                :name => addon["name"],
                :description => addon["description"],
                :attachment => addon["attachment_name"],
                :url => addon["sso_url"]
              }
            end)
          }
        end)
      }
    end)

    render conn, "index.html", apps: apps
  end

  def addon(conn, %{"app" => app, "addon" => addon_name}) do
    {_, addons} = Heroku.Addon.list_existing_addons_for_an_app(app)
    [url | _] = Enum.filter_map(addons, fn(addon) -> addon["name"] == addon_name end, &(&1["sso_url"]))
    redirect(conn, external: url)
  end
end
