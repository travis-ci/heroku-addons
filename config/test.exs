use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :meta_dashboard, MetaDashboard.Endpoint,
  http: [port: 4001],
  server: true

config :meta_dashboard,
  heroku_apps: ~w(a1 a2)

# Print only warnings and errors during test
config :logger, level: :warn

config :hound, driver: "phantomjs"
