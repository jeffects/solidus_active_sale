# EVENTS
# Events represent an entity for active sale in a flash sale/ daily deal.
# There can be many events for one sale, just like taxonomies in spree.
#
module Spree
  class ActiveSaleEvent < Spree::SaleEvent
    acts_as_nested_set :dependent => :destroy, :polymorphic => true

    before_validation :update_permalink
    before_save :have_valid_position
    after_save :update_parent_active_sales, :update_active_sale_position

    #TODO has_many :sale_images, :as => :viewable, :dependent => :destroy, :order => 'position ASC'
    belongs_to :product
    belongs_to :active_sale

#    attr_accessible :description, :end_date, :eventable_id, :eventable_type, :is_active, :is_hidden, :is_permanent, :name, :permalink, :active_sale_id, :start_date, :eventable_name, :discount, :parent_id

    validates :name, :permalink, :eventable_id, :start_datetime, :end_datetime, :active_sale_id, :presence => true

    # Spree::ActiveSaleEvent.is_live? method
    # should only/ always represents live and active events and not just live events.
    def is_live? object
      object_class_name = object.class.name
      return object.live_and_active? if object_class_name == self.name
      %w(Spree::Product Spree::Variant Spree::Taxon).include?(object_class_name) ? object.live? : false
    end

    def product_name
      product.try(:name)
    end

    def product_name=(name)
      self.product = Product.find_by_name(name) if name.present?
    end

    def update_permalink
      prefix = {"Spree::Taxon" => "t", "Spree::Product" => "products"}
      self.permalink = [prefix[self.eventable_type], self.eventable.friendly_id].join("/") unless self.eventable.nil?
    end

    # This callback basically makes sure that parents for an event lives longer.
    # Or at least parents live for the time when event is live.
    def update_parent_active_sales
      active_sale_events = self.self_and_ancestors
      parents = self.ancestors
      oldest_start_datetime = active_sale_events.not_blank_and_sorted_by(:start_datetime).first
      latest_end_datetime = active_sale_events.not_blank_and_sorted_by(:end_datetime).last
      parents.each{ |parent| 
        parent.update_attributes(:start_datetime => oldest_start_datetime) if parent.start_datetime.nil? ? true : (parent.start_datetime > oldest_start_datetime) 
        parent.update_attributes(:end_datetime => latest_end_datetime) if parent.end_datetime.nil? ? true : (parent.end_datetime < latest_end_datetime)
      }
    end
  end
end
