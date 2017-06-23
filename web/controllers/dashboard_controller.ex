defmodule HerokuAddons.DashboardController do
  use HerokuAddons.Web, :controller

  def index(conn, _params) do
    apps = Enum.map(Application.get_env(:heroku_addons, :heroku_apps), fn(app) ->
      {:ok, addons} = Heroku.AddOn.list_existing_addons_for_an_app(app)
      {:ok, attachments} = Heroku.AddOnAttachment.list_existing_addon_attachments_for_an_app(app)

      attachments_by_addon_id = attachments |> Enum.group_by(&(&1["addon"]["id"]))

      %{
        :name => app,
        :groups => Enum.map(Enum.group_by(addons, &(&1["addon_service"]["name"])), fn {group, addons} ->
          %{
            :name => group,
            :addons => Enum.map(addons, fn(addon) ->
              %{
                :name => addon["name"],
                :attachments => attachments_by_addon_id[addon["id"]] |> Enum.map(&(&1["name"])),
                :url => addon["web_url"],
              }
            end)
          }
        end)
      }
    end)

    render conn, "index.html", apps: apps
  end

  def addon(conn, %{"app" => app, "addon" => addon_name}) do
    {_, addons} = Heroku.AddOn.list_existing_addons_for_an_app(app)
    [url | _] = Enum.filter_map(addons, fn(addon) -> addon["name"] == addon_name end, &(&1["web_url"]))
    redirect(conn, external: url)
  end
end
