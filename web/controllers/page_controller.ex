defmodule MetaDashboard.PageController do
  use MetaDashboard.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", apps: ~w{travis-production travis-pro-production}
  end
end
