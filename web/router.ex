defmodule HerokuAddons.Router do
  use HerokuAddons.Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", HerokuAddons do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", DashboardController, :index)
    get("/:app/:addon", DashboardController, :addon)
  end

  # Other scopes may use custom stacks.
  # scope "/api", HerokuAddons do
  #   pipe_through :api
  # end
end
