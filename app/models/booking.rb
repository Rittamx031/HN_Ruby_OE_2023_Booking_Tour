class Booking < ApplicationRecord
  BOOKING_PARAMS = [:phone, :numbers_people, :tour_detail_id,
                    :date_start, :user_id].freeze
  CANCEL_PARAMS = [:reason].freeze
  belongs_to :tour_detail
  belongs_to :user
  has_one :review, dependent: :destroy, class_name: Review.name
  validates :phone, presence: true, phone: true, on: :create
  validates :date_start, presence: true, allow_nil: true, on: :create
  validates :reason, presence: true, on: :update,
            if: ->{status.to_sym == :canceled}
  validates :numbers_people, presence: true,
            numericality: {only_integer: true,
                           greater_than_or_equal_to:
                           Settings.peoples_booking_min}
  validate :booking_date_in_future, on: :create
  validate :out_of_peoples, if: ->{numbers_people.present?}
  scope :new_bills, ->{order(created_at: :desc)}
  scope :overtimebooking, -> { where(status: 0).where("date_start >= ?", Time.zone.now) }
  scope :successbooking, -> { where(status: 1).where("end_date <= ?", Settings.success_3_days.days.ago) }
  before_create :update_prices, :status_booking
  before_save :caculate_end_date
  enum status: {
    pending: 0,
    confirmed: 1,
    canceled: 2,
    successed: 3
  }

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
    BookingMailer.with(user: user, booking: self).successed_booking.deliver_later if user.present?
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

  def update_prices
    self.total_amount = tour_detail.price * numbers_people
  end

  def status_booking
    self.status = :pending
    self.booking_date = Time.zone.now
  end

  def caculate_end_date
    self.end_date = date_start + tour_detail.time_duration.days
  end
end
