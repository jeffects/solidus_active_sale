module Spree
  module Admin
    class ActiveSalesController < ResourceController
      before_filter :load_active_sale_events, :only => [:new, :edit]
      before_filter :set_active_sale, :only => [:create, :update]
      respond_to :json, :only => [:get_children]

      def index
        respond_with(@collection) do |format|
          format.html
          format.json { render :json => json_data }
        end
      end

      def show
        redirect_to edit_object_url(@active_sale)
      end

      def create
        if @active_sale = ActiveSale.create(active_sale_params)
          flash[:success] = Spree.t(:successfully_created)
          redirect_to admin_active_sale_path(@active_sale)
        else
          flash[:error] = Spree.t(:error_on_create)
          render :new
        end
      end

      def update
        if @active_sale.update_attributes!(active_sale_params)
          flash[:success] = Spree.t(:successfully_updated)
          redirect_to admin_active_sale_path(@active_sale)
        else
          flash[:error] = Spree.t(:error_on_update)
          render :edit
        end


      end

      def products
        search = Product.search(:name_cont => params[:name])
        render :json => search.result.map(&:name)
      end

      protected

        def collection
          return @collection if @collection.present?
          @search = Spree::ActiveSale.includes(:active_sale_events).ransack(params[:q])
          @collection = @search.result.page(params[:page]).per(Spree::ActiveSaleConfig[:admin_active_sales_per_page])
        end

        def load_active_sale_events
          if @active_sale.new_record?
            @active_sale_event = @active_sale.active_sale_events.build
          else
            @active_sale_event = @active_sale.active_sale_events.first
            @active_sale_events = @active_sale.active_sale_events
          end
        end

        def set_active_sale
          return false if params[:active_sale_event].blank?
          params[:active_sale] = params[:active_sale_event]
          params[:active_sale].delete(:discount)
        end

      def active_sale_params
        params.require(:active_sale).permit(permitted_active_sale_attributes).merge(product_hash)
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
