defmodule MetaDashboard.Router do
  use MetaDashboard.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MetaDashboard do
    pipe_through :browser # Use the default browser stack

    get "/", DashboardController, :index
    get "/:app/:addon", DashboardController, :addon
  end

  # Other scopes may use custom stacks.
  # scope "/api", MetaDashboard do
  #   pipe_through :api
  # end
end
