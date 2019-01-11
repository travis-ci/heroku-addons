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
          case app do
            "missing" ->
              {:error, %{"id" => "not_found", "message" => "Couldn't find that app.", "resource" => "app"}}
            _ ->
              {:ok, [
                %{"id" => "1", "name" => "#{app}-addon-one-1234", "plan" => %{"name" => "addon-one"}, "web_url" => "https://heroku.com/addons/#{app}-addon-one-1234", "addon_service" => %{"name" => "group one"}},
                %{"id" => "2", "name" => "#{app}-addon-two-2345", "plan" => %{"name" => "addon-two"}, "web_url" => "https://heroku.com/addons/#{app}-addon-two-2345", "addon_service" => %{"name" => "group one"}},
                %{"id" => "3", "name" => "#{app}-addon-lonely-3456", "plan" => %{"name" => "addon-lonely"}, "addon_service" => %{"name" => "group lonely"}}]}
          end
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

      assert visible_text({:css, ".addon[data-app=a1][data-name=a1-addon-one-1234] a.external"}) == "addon-one"
      assert visible_text({:css, ".addon[data-app=a1][data-name=a1-addon-one-1234] .description"}) == "a1-addon-one-1234"
      assert visible_text({:css, ".addon[data-app=a1][data-name=a1-addon-one-1234] .attachment"}) == "JORTS"
      assert attribute_value({:css, ".addon[data-app=a1][data-name=a1-addon-one-1234] a.external"}, "href") == "https://heroku.com/addons/a1-addon-one-1234"
      assert String.ends_with?(attribute_value({:css, ".addon[data-app=a1][data-name=a1-addon-one-1234] a.shortcut"}, "href"), "/a1/a1-addon-one-1234")

      assert visible_text({:css, ".addon[data-app=a1][data-name=a1-addon-two-2345] a.external"}) == "addon-two"
      refute Hound.Element.element?({:css, ".addon[data-app=a1][data-name=a1-addon-two-2345] .attachment"})
      assert attribute_value({:css, ".addon[data-app=a1][data-name=a1-addon-two-2345] a.external"}, "href") == "https://heroku.com/addons/a1-addon-two-2345"
      assert String.ends_with?(attribute_value({:css, ".addon[data-app=a1][data-name=a1-addon-two-2345] a.shortcut"}, "href"), "/a1/a1-addon-two-2345")

      assert visible_text({:css, ".app[data-name=a2] a"}) == "a2"

      assert visible_text({:css, ".group[data-name='group lonely'] .name"}) == "group lonely"

      assert visible_text({:css, ".app[data-name=missing] h4"}) == "missing: error fetching addons"
    end
  end
end
