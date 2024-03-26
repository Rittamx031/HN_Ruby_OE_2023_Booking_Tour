class BookingsController < ApplicationController
  before_action :check_user,
                only: %i(new create booking_history)
  before_action :find_tour_detail, only: %i(new)
  before_action :find_booking, only: %i(show cancel)
  before_action :check_owner, only: %i(cancel)
  def new
    @booking = build_booking
  end

  def create
    @booking = Booking.new(booking_params)
    if @booking.save
      flash[:success] = t("bookings.create_success")
      redirect_to history_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def cancel
    begin
      @booking.cancel_booking({"reason" => Settings.user_reason_cancel})
      flash[:success] = t("bookings.cancel_success")
    rescue RuntimeError => e
      flash[:danger] = e
    end
    redirect_to history_url
  end

  def show; end

  def booking_history
    @pagy, @bookings = pagy(current_user.bookings)
    render "bookings/index"
  end

  private
  def check_owner
    return if current_user == @booking.user

    flash[:warning] = t("controllers.errors.requied_login")
    redirect_to root_path
  end

  def find_tour_detail
    @tour_detail = TourDetail.find_by(id: params[:id])
    return if @tour_detail

    flash[:warning] = t("controllers.errors.tour_detail_not_found")
    redirect_to root_path
  end

  def find_booking
    @booking = Booking.find_by(id: params[:id])
    return if @booking

    flash[:warning] = t("controllers.errors.booking_not_found")
    redirect_to root_path
  end

  def booking_params
    params.require(:booking).permit(Booking::BOOKING_PARAMS)
  end

  def build_booking
    Booking.new(
      tour_detail: @tour_detail,
      user: current_user,
      numbers_people: Settings.peoples_booking_tours
    )
  end
end
