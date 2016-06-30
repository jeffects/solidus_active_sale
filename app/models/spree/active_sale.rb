# ActiveSales
# Active sales represent an entity for one sale at a time, just like a taxonomy in spree.
# For example: 'January 2013' sale, which can have many sale events in it.
#
module Spree
  class ActiveSale < Spree::SaleEvent
    validates :name, :presence => true
    validate :start_and_end_date_presence, :start_and_end_date_range

    has_many :active_sale_events

    before_save :have_valid_position

    default_scope { order("#{self.table_name}.position") }

    def self.config(&block)
      yield(Spree::ActiveSaleConfig)
    end

    private

      def start_and_end_date_presence
        errors.add(:start_datetime, I18n.t('spree.active_sale.event.validation.errors.date_empty')) if self.start_datetime.nil?
        errors.add(:end_datetime, I18n.t('spree.active_sale.event.validation.errors.date_empty')) if self.end_datetime.nil?
      end

      # This should validate the start and end date range between
      # its active_sale_events. To make sure that, root lives longer.
      def start_and_end_date_range
        unless self.start_datetime.nil? || self.end_datetime.nil?
          oldest_start_datetime = self.active_sale_events.not_blank_and_sorted_by(:start_datetime).first
          latest_end_datetime = self.active_sale_events.not_blank_and_sorted_by(:end_datetime).last
          errors.add(:start_datetime, I18n.t('spree.active_sale.event.validation.errors.invalid_root_dates')) if (oldest_start_datetime.nil? && latest_end_datetime.nil?) ? false : (self.start_datetime > oldest_start_datetime || self.end_datetime < latest_end_datetime)
        end
      end
  end
end
