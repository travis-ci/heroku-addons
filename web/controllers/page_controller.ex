defmodule MetaDashboard.PageController do
  use MetaDashboard.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
