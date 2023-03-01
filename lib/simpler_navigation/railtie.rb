require "rails/railtie"
require "simpler_navigation/view_helpers"

module SimplerNavigation
  class Railtie < ::Rails::Railtie
    initializer "simpler_navigation.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        include ViewHelpers
      end
    end
  end
end
