class Booking < ApplicationRecord
  BOOKING_PARAMS = [:phone, :numbers_people, :tour_detail_id,
                    :date_start, :user_id, :cccd].freeze
  CANCEL_PARAMS = [:reason].freeze
  belongs_to :tour_detail
  belongs_to :user
  has_one :review, dependent: :destroy, class_name: Review.name
  validates :phone, presence: true, phone: true, on: :create
  validates :cccd, presence: true, allow_nil: true
  validates :date_start, presence: true, allow_nil: true, on: :create
  validates :reason, presence: true, on: :update,
            if: ->{status.to_sym == :canceled}
  validates :numbers_people, presence: true,
            numericality: {only_integer: true,
                           greater_than_or_equal_to:
                           Settings.peoples_booking_min}
  validate :booking_date_in_future, on: :create
  validate :out_of_peoples, if: ->{numbers_people.present?}
  validate :cccd_valid, if: ->{cccd.present?}
  scope :new_bills, ->{order(created_at: :desc)}
  scope :incomes, lambda {|date_form, date_to|
    where(status: :successed)
      .group_by_day(:created_at,
                    range: date_form..date_to,
                    format: Settings.dd_mm_yyyy_fm)
      .sum(:total_amount)
  }
  scope :new_bookings, lambda {|date_form, date_to|
    where(created_at: date_form..date_to)
      .group(:tour_detail)
      .count
  }
  scope :status_bookings, lambda {|date_form, date_to|
    where(created_at: date_form..date_to)
      .group(:status)
      .count
  }
  scope :overtime_booking, (lambda do
    where(status: :pending).where("date_start >= ?", Time.zone.now)
  end)
  scope :success_booking, (lambda do
    where(status: :confirmed).where("end_date < ?", Time.zone.now)
  end)
  before_create :update_prices, :status_booking
  before_save :caculate_end_date
  enum status: {
    pending: 0,
    confirmed: 1,
    canceled: 2,
    successed: 3
  }

  class << self
    def new_booking_hash_order date_from, date_to
      bookings = new_bookings(date_from, date_to)
      transformed_bookings = bookings.transform_keys do |key|
        key.is_a?(TourDetail) ? key[:tour_detail_name] : key
      end
      transformed_bookings.sort_by{|_k, v| -v}
    end
  end

  def cancel_booking params
    reload
    unless pending?
      errors.add(:status, I18n.t("bookings.errors.update_status_fail"))
      raise I18n.t("bookings.errors.update_status_fail")
    end
    raise I18n.t("bookings.errors.update_status_fail") unless update params

    canceled!
    CancelBookingMailJob.perform_async(id)
  end

  def confirm_booking
    reload
    raise I18n.t("bookings.errors.update_status_fail") unless pending?

    confirmed!
    ConfirmBookingMailJob.perform_async(id)
  end

  def successed_booking
    reload
    raise I18n.t("bookings.errors.update_status_fail") unless confirmed?

    successed!
    SuccessBookingMailJob.perform_async(id)
  end
  private

  def booking_date_in_future
    return unless date_start.present? && date_start <= Time.zone.now

    errors.add(:date_start, I18n.t("bookings.errors.date_in_fulture"))
  end

  def out_of_peoples
    return if numbers_people <= tour_detail.max_people

    errors.add(:numbers_people,
               I18n.t("bookings.errors.out_of_people",
                      max_people: tour_detail.max_people))
  end

  def cccd_valid?
    return if cccd =~ /\A\d{9,12}\z/

    errors.add(:cccd, I18n.t("bookings.errors.cccd_invalid"))
  end

  def update_prices
    self.total_amount = tour_detail.price * numbers_people
  end

  def status_booking
    self.status = :pending
  end

  def caculate_end_date
    self.end_date = date_start + tour_detail.time_duration.days
  end
end
