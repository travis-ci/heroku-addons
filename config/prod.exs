use Mix.Config

config :heroku_addons, HerokuAddons.Endpoint,
  http: [port: 4000],
  url: [host: "heroku-addons.travis-ci.org", port: 443],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info
