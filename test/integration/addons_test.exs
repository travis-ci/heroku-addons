defmodule MetaDashboard.Integration.Addons do
  use MetaDashboard.ConnCase

  import Mock

  # Import Hound helpers
  use Hound.Helpers

  # Start a Hound session
  hound_session

  test "registering" do
    with_mock Heroku.Addon, [list_existing_addons_for_an_app: fn(app) -> {:ok, [%{"name" => "#{app}-addon-one"}, %{"name" => "#{app}-addon-two"}]} end] do
      navigate_to "/"

      assert visible_text({:css, ".app:nth-child(1) > .name"}) == "travis-production"
      assert visible_text({:css, ".app:nth-child(1) .addon:nth-child(1) .name"}) == "travis-production-addon-one"
      assert visible_text({:css, ".app:nth-child(1) .addon:nth-child(2) .name"}) == "travis-production-addon-two"

      assert visible_text({:css, ".app:nth-child(2) > .name"}) == "travis-pro-production"
      assert visible_text({:css, ".app:nth-child(2) .addon:nth-child(1) .name"}) == "travis-pro-production-addon-one"
      assert visible_text({:css, ".app:nth-child(2) .addon:nth-child(2) .name"}) == "travis-pro-production-addon-two"
    end
  end
end
