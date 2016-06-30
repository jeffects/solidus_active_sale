module Spree
  module Admin
    class ActiveSaleEventsController < ResourceController
      belongs_to 'spree/active_sale', :find_by => :id
      before_filter :load_active_sale, :only => [:index]
      respond_to :json, :only => [:update_events]

      def show
        redirect_to( :action => :edit )
      end

      def destroy
        @active_sale_event = Spree::ActiveSaleEvent.find(params[:id])
        @active_sale_event.destroy
        respond_with(@active_sale_event) { |format| format.json { render :json => '' } }
      end

      def update_events
        @active_sale_event.update_attributes(params[:active_sale_event])
        respond_with(@active_sale_event)
      end

      protected

        def collection
          return @collection if @collection.present?
          @search = Spree::ActiveSaleEvent.where(:active_sale_id => params[:active_sale_id]).ransack(params[:q])
          @collection = @search.result.page(params[:page]).per(Spree::ActiveSaleConfig[:admin_active_sale_events_per_page])
        end

        def load_active_sale
          @active_sale = Spree::ActiveSale.find(params[:active_sale_id])
        end

    end
  end
end
