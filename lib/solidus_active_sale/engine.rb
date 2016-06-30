module SolidusActiveSale
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'solidus_active_sale'

    initializer "spree_active_sale.environment", :before => "spree.environment" do |app|
      Spree::ActiveSaleConfig = Spree::ActiveSaleConfiguration.new
#      %w(ActionController::Base Spree::BaseController).each { |controller| 
#        controller.constantize.send(:helper, Spree::ActiveSaleEventsHelper)
#        controller.constantize.send(:helper, Spree::ActiveSalesHelper)
#      }
    end

    config.to_prepare do
      ApplicationController.send :include, Spree::ActiveSaleEventsHelper
      ApplicationController.send :include, Spree::ActiveSalesHelper
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer "spree.assets.precompile", :group => :all do |app|
      app.config.assets.precompile += %w[
        admin/spree_active_sale_event/edit.js
      ]
    end

    config.to_prepare &method(:activate).to_proc
  end
end
