defmodule HerokuAddons.Integration.Addons do
  use HerokuAddons.ConnCase

  import Mock

  # Import Hound helpers
  use Hound.Helpers

  # Start a Hound session
  hound_session()

  test "registering" do
    with_mocks [
        {Heroku.AddOn,
         [],
         [list_existing_addons_for_an_app: fn(app) ->
          {:ok, [
            %{"id" => "1", "name" => "#{app}-addon-one-1234", "plan" => %{"name" => "addon-one"}, "web_url" => "https://heroku.com/addons/#{app}-addon-one", "addon_service" => %{"name" => "group one"}},
            %{"id" => "2", "name" => "#{app}-addon-two-2345", "plan" => %{"name" => "addon-two"}, "web_url" => "https://heroku.com/addons/#{app}-addon-two", "addon_service" => %{"name" => "group one"}},
            %{"id" => "3", "name" => "#{app}-addon-lonely-3456", "plan" => %{"name" => "addon-lonely"}, "addon_service" => %{"name" => "group lonely"}}]}
          end]},
        {Heroku.AddOnAttachment,
         [],
         [list_existing_addon_attachments_for_an_app: fn(_) ->
          {:ok, [
            %{"name" => "JORTS", "addon" => %{"id" => "1"}},
            %{"addon" => %{"id" => "2"}},
            %{"addon" => %{"id" => "3"}}]}
          end]}
      ] do
      navigate_to "/"

      assert visible_text({:css, ".app[data-name=a1] a"}) == "a1"
      assert attribute_value({:css, ".app[data-name=a1] a"}, "href") == "https://dashboard.heroku.com/apps/a1"

      assert visible_text({:css, ".group[data-name='group one'] .name"}) == "group one"

      assert visible_text({:css, ".addon[data-app=a1][data-name=a1-addon-one] a.external"}) == "addon-one"
      assert visible_text({:css, ".addon[data-app=a1][data-name=a1-addon-one] .description"}) == "a1-addon-one-1234"
      assert visible_text({:css, ".addon[data-app=a1][data-name=a1-addon-one] .attachment"}) == "JORTS"
      assert attribute_value({:css, ".addon[data-app=a1][data-name=a1-addon-one] a.external"}, "href") == "https://heroku.com/addons/a1-addon-one"
      assert String.ends_with?(attribute_value({:css, ".addon[data-app=a1][data-name=a1-addon-one] a.shortcut"}, "href"), "/a1/a1-addon-one")

      assert visible_text({:css, ".addon[data-app=a1][data-name=a1-addon-two] a.external"}) == "addon-two"
      refute Hound.Element.element?({:css, ".addon[data-app=a1][data-name=a1-addon-two] .attachment"})
      assert attribute_value({:css, ".addon[data-app=a1][data-name=a1-addon-two] a.external"}, "href") == "https://heroku.com/addons/a1-addon-two"
      assert String.ends_with?(attribute_value({:css, ".addon[data-app=a1][data-name=a1-addon-two] a.shortcut"}, "href"), "/a1/a1-addon-two")

      assert visible_text({:css, ".app[data-name=a2] a"}) == "a2"

      assert visible_text({:css, ".group[data-name='group lonely'] .name"}) == "group lonely"
    end
  end
end
