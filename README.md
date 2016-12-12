# Heroku Addons [![Build Status](https://travis-ci.org/travis-ci/heroku-addons.svg?branch=primary)](https://travis-ci.org/travis-ci/heroku-addons)

This is collection of links to Heroku app addons.

The app list is determined from the `HEROKU_APPS` environment variable, which should be space-separated.

The `HEROKU_ACCESS_TOKEN` environment variable is required for Heroku API access.

To start the application:

  * Install the [requirements to run Elixir](http://www.phoenixframework.org/docs/installation)
  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Tests

The integration test requires PhantomJS.

* `phantomjs -w`
* `mix test`

## Deployment

The [deployment](https://heroku-addons.travis-ci.org/) is sitting behind the [sso](https://github.com/travis-ci/sso)
reverse proxy, via the [`makey-go`](https://github.com/travis-ci/heroku-buildpack-makey-go.git) buildpack. This requires
it to live at a `travis-ci.{org,com}` domain.

Here are the environment variables configured:

| Environment variable   | Value                                                                                    |
|------------------------|------------------------------------------------------------------------------------------|
| `HEROKU_ACCESS_TOKEN`  |                                                                                          |
| `SECRET_KEY_BASE`      | `mix phoenix.gen.secret`                                                                 |
| `SSO_APP_PUBLIC_URL`   | https://heroku-addons.travis-ci.org                                                      |
| `SSO_AUTHORIZED_USERS` | A comma-separated, no-whitespace list of GitHub usernames for users who can access this. |
| `SSO_CSRF_KEY`         | `echo $RANDOM | md5`                                                                     |
| `SSO_ENCRYPTION_KEY`   | `echo $RANDOM | md5`                                                                     |
| `SSO_UPSTREAM_PORT`    | `4000`, as set in `config/prod.exs`                                                      |

Here are the buildpacks:

1. https://github.com/travis-ci/heroku-buildpack-makey-go.git
2. https://github.com/HashNuke/heroku-buildpack-elixir.git
3. https://github.com/gjaldon/heroku-buildpack-phoenix-static.gitb
