module Spree
  HomeController.class_eval do

    # List live and active sales on home page
    def index
      @sale_events = all_active_sale_events
      @sale_event = all_active_sale_events.first
      respond_with(@sale_events)
    end
  end
end
