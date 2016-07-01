module Spree
  module Admin

    class ActiveSaleEventsController < ResourceController
      respond_to :json, :only => [:update_events]

      def index
        respond_with(@collection) do |format|
          format.html
          format.json { render :json => json_data }
        end
      end

      def show
        redirect_to( :action => :edit )
      end

      def destroy
        @active_sale_event = Spree::ActiveSaleEvent.find(params[:id])
        @active_sale_event.destroy
        respond_with(@active_sale_event) { |format| format.json { render :json => '' } }
      end

      def products
        search = Product.search(:name_cont => params[:name])
        render :json => search.result.map(&:name)
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

        def permitted_active_sale_attributes
          [
            :name, :description, :permalink, :start_datetime, :end_datetime,
            :is_active, :is_hidden, :is_permanent, :discount_percentage, :product_id
          ]
        end

        def product_hash
          if product_name = params[:active_sale].delete(:product_name)
            product = Product.find_by_name(product_name)
            { product_id: product.id, permalink: product.friendly_id }
          else
            {}
          end
        end



    end
  end
end
