# HerokuAddons [![Build Status](https://travis-ci.org/travis-ci/heroku-addons.svg?branch=primary)](https://travis-ci.org/travis-ci/heroku-addons)

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
