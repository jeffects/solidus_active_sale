# encoding: utf-8
# Sale Event
# Sale Event represents active sale and active sale event by using STI.
# There can be many events for one sale.
#
module Spree
  class SaleEvent < ActiveRecord::Base
    #attr_accessible :description, :end_datetime, :eventable_id, :eventable_type, :is_active, :is_hidden, :is_permanent, :name, :permalink, :active_sale_id, :start_date, :eventable_name, :type, :parent_id, :position

#    acts_as_nested_set :dependent => :destroy

    scope :live, lambda { where("(start_datetime <= :start_datetime AND end_datetime >= :end_datetime) OR is_permanent = :is_permanent", { :start_datetime => zone_time, :end_datetime => zone_time, :is_permanent => true }) }
    scope :active, lambda { |*args| where(:is_active => valid_argument(args)) }
    scope :hidden, lambda { |*args| where(:is_hidden => valid_argument(args)) }
    scope :live_active, lambda { |*args| self.live.active(valid_argument(args)) }
    scope :live_active_and_hidden, lambda { |*args| 
                            args = [{}] if [nil, true, false].include? args.first
                            self.live.active(valid_argument([args.first[:active]])).hidden(valid_argument([args.first[:hidden]])) 
                          }
    scope :upcoming_events, lambda { where("start_datetime > :start_datetime", { :start_datetime => zone_time }) }
    scope :past_events, lambda { where("end_datetime < :end_datetime", { :end_datetime => zone_time }) }
    scope :starting_today, lambda { where(:start_datetime => zone_time..zone_time.end_of_day) }
    scope :ending_today, lambda { where(:end_datetime => zone_time..zone_time.end_of_day) }
    belongs_to :product, class_name: 'Spree::Product'

    validate :validate_start_and_end_date

    def live?(moment=nil)
      moment ||= object_zone_time
      (self.start_datetime <= moment and self.end_datetime >= moment) or self.is_permanent? if start_and_end_dates_available?
    end

    def upcoming?
      current_time = object_zone_time
      (self.start_datetime >= current_time and self.end_datetime > self.start_datetime) if start_and_end_dates_available?
    end

    def past?
      current_time = object_zone_time
      (self.start_datetime < current_time and self.end_datetime > self.start_datetime and self.end_datetime < current_time) if start_and_end_dates_available?
    end

    def live_and_active?(moment=nil)
      self.live?(moment) and self.is_active?
    end

    def start_and_end_dates_available?
      self.start_datetime and self.end_datetime
    end

    def invalid_dates?
      self.start_and_end_dates_available? and (self.start_datetime >= self.end_datetime)
    end

    # Class methods
    class << self
      def paginate(objects_per_page, options = {})
        options = prepare_pagination(objects_per_page, options)
        self.page(options[:page]).per(options[:per_page])
      end

      def not_blank_and_sorted_by(column)
        return nil if column.blank? 
        column = column.to_sym
        self.select(&column).map(&column).reject(&:blank?).sort
      end

      private
        def valid_argument args
          (args.first == nil || args.first == true)
        end

        def prepare_pagination(objects_per_page, options)
          per_page = options[:per_page].to_i
          options[:per_page] = per_page > 0 ? per_page : Spree::ActiveSaleConfig[objects_per_page]
          page = options[:page].to_i
          options[:page] = page > 0 ? page : 1
          options
        end

        def zone_time
          Time.zone.now
        end
    end

    private
      
      def object_zone_time
        Time.zone.now
      end

      def validate_start_and_end_date
        errors.add(:start_datetime, I18n.t('spree.active_sale.event.validation.errors.invalid_dates')) if invalid_dates?
      end

      def have_valid_position
        self.position ||= self.class.select(:id).all.size
      end
  end
end

