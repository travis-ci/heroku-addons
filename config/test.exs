use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :heroku_addons, HerokuAddons.Endpoint,
  http: [port: 4001],
  server: true

config :heroku_addons, heroku_apps: ~w(a1 a2 missing)

# Print only warnings and errors during test
config :logger, level: :warn

config :hound, driver: "phantomjs"
