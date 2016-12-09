defmodule MetaDashboard.Integration.Addons do
  use MetaDashboard.ConnCase

  import Mock

  # Import Hound helpers
  use Hound.Helpers

  # Start a Hound session
  hound_session

  test "registering" do
    with_mock Heroku.Addon, [list_existing_addons_for_an_app: fn(app) -> {:ok, [%{"name" => "#{app}-addon-one", "sso_url" => "https://heroku.com/addons/#{app}-addon-one"}, %{"name" => "#{app}-addon-two", "sso_url" => "https://heroku.com/addons/#{app}-addon-two"}]} end] do
      navigate_to "/"

      assert visible_text({:css, ".app:nth-child(1) > .name"}) == "travis-production"

      assert visible_text({:css, ".app:nth-child(1) .addon:nth-child(1) a.external"}) == "travis-production-addon-one"
      assert attribute_value({:css, ".app:nth-child(1) .addon:nth-child(1) a.external"}, "href") == "https://heroku.com/addons/travis-production-addon-one"
      assert String.ends_with?(attribute_value({:css, ".app:nth-child(1) .addon:nth-child(1) a.shortcut"}, "href"), "/travis-production/travis-production-addon-one")

      assert visible_text({:css, ".app:nth-child(1) .addon:nth-child(2) a.external"}) == "travis-production-addon-two"
      assert attribute_value({:css, ".app:nth-child(1) .addon:nth-child(2) a.external"}, "href") == "https://heroku.com/addons/travis-production-addon-two"
      assert String.ends_with?(attribute_value({:css, ".app:nth-child(1) .addon:nth-child(2) a.shortcut"}, "href"), "/travis-production/travis-production-addon-two")

      assert visible_text({:css, ".app:nth-child(2) > .name"}) == "travis-pro-production"
      assert visible_text({:css, ".app:nth-child(2) .addon:nth-child(1) a"}) == "travis-pro-production-addon-one"
      assert visible_text({:css, ".app:nth-child(2) .addon:nth-child(2) a"}) == "travis-pro-production-addon-two"
    end
  end
end
