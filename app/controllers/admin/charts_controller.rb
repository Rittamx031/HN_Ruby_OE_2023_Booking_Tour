class Admin::ChartsController < ApplicationController
  before_action :validate_filter_params, only: %i(filter)
  before_action :range_filter, expect: %i(filter)

  def incomes
    render json: Booking.where(status: :successed)
                        .group_by_day(:created_at,
                                      range: @datefrom..@dateto,
                                      format: "%d-%m-%Y")
                        .sum(:total_amount)
  end

  def status_booking
    render json: Booking.where(created_at: @datefrom..@dateto)
                        .group(:status).count
  end

  def new_booking
    @booking = Booking.where(created_at: @datefrom..@dateto)
                      .group(:tour_detail)
                      .count
                      .transform_keys! do |key|
                        key.is_a?(TourDetail) ? key[:tour_detail_name] : key
                      end
    @booking.sort_by{|_k, v| -v}
    render json: @booking
  end

  def users_signup
    render json: User.group_by_day_of_week(:created_at,
                                           range: @datefrom..@dateto,
                                           format: "%a")
                     .count
  end

  def filter; end

  private

  def validate_filter_params
    @parsed_date_form = Date.parse(params[:dateform])
    @parsed_date_to = Date.parse(params[:dateto])

    handle_date_order_error if @parsed_date_form >= @parsed_date_to
  rescue ArgumentError
    handle_invalid_date_format_error
  end

  def handle_date_order_error
    flash[:danger] = t("home.date_order")
    redirect_to admin_dashboard_path
  end

  def handle_invalid_date_format_error
    flash[:danger] = t("home.invalid_format")
    redirect_to admin_dashboard_path
  end

  def range_filter
    @datefrom = parse_date(params[:datefrom])&.beginning_of_day ||
                Time.zone.now.beginning_of_month.midnight
    @dateto = parse_date(params[:dateto])&.end_of_day ||
              Time.zone.now
  end

  def parse_dat date_param
    Time.zone.parse(date_param) if date_param.present?
  end
end
