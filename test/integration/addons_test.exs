defmodule HerokuAddons.Integration.Addons do
  use HerokuAddons.ConnCase

  import Mock

  # Import Hound helpers
  use Hound.Helpers

  # Start a Hound session
  hound_session

  test "registering" do
    with_mock Heroku.Addon, [list_existing_addons_for_an_app: fn(app) ->
      {:ok, [
        %{"name" => "#{app}-addon-one", "description" => "Addon one!", "attachment_name" => "JORTS", "sso_url" => "https://heroku.com/addons/#{app}-addon-one", "group_description" => "group one"},
        %{"name" => "#{app}-addon-two", "sso_url" => "https://heroku.com/addons/#{app}-addon-two", "group_description" => "group one"},
        %{"name" => "#{app}-addon-lonely", "group_description" => "group lonely"}
      ]}
    end] do
      navigate_to "/"

      assert visible_text({:css, ".app[data-name=a1] a"}) == "a1"
      assert attribute_value({:css, ".app[data-name=a1] a"}, "href") == "https://dashboard.heroku.com/apps/a1"

      assert visible_text({:css, ".group[data-name='group one'] .name"}) == "group one"

      assert visible_text({:css, ".addon[data-app=a1][data-name=a1-addon-one] a.external"}) == "a1-addon-one"
      assert visible_text({:css, ".addon[data-app=a1][data-name=a1-addon-one] .description"}) == "Addon one!"
      assert visible_text({:css, ".addon[data-app=a1][data-name=a1-addon-one] .attachment"}) == "JORTS"
      assert attribute_value({:css, ".addon[data-app=a1][data-name=a1-addon-one] a.external"}, "href") == "https://heroku.com/addons/a1-addon-one"
      assert String.ends_with?(attribute_value({:css, ".addon[data-app=a1][data-name=a1-addon-one] a.shortcut"}, "href"), "/a1/a1-addon-one")

      assert visible_text({:css, ".addon[data-app=a1][data-name=a1-addon-two] a.external"}) == "a1-addon-two"
      refute Hound.Element.element?({:css, ".addon[data-app=a1][data-name=a1-addon-two] .attachment"})
      assert attribute_value({:css, ".addon[data-app=a1][data-name=a1-addon-two] a.external"}, "href") == "https://heroku.com/addons/a1-addon-two"
      assert String.ends_with?(attribute_value({:css, ".addon[data-app=a1][data-name=a1-addon-two] a.shortcut"}, "href"), "/a1/a1-addon-two")

      assert visible_text({:css, ".app[data-name=a2] a"}) == "a2"

      assert visible_text({:css, ".group[data-name='group lonely'] .name"}) == "group lonely"
    end
  end
end
