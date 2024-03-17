class Admin::BillsController < Admin::BaseController
  before_action :find_bill, only: %i(confirm cancel_modal submit_cancel)
  def index
    @filter = ransack_params
    @filter.sorts ||= "created_at asc"
    @pagy, @bills = pagy(@filter.result(distinct: true))
  end

  def cancel_modal; end

  def submit_cancel
    @bill.cancel_booking(cancel_params)
    flash.now[:success] = t("bookings.cancel_success")
    render :success_cancel
  rescue RuntimeError, ActiveRecord::RecordInvalid => e
    flash.now[:danger] = e
    render :cancel_valid, status: :unprocessable_entity
  end

  def confirm
    if @bill.confirm_booking
      flash.now[:success] = t("bookings.confirm_success")
    else
      flash.now[:error] = t("bookings.confirm_error")
    end
  end

  private

  def ransack_params
    Booking.ransack(params[:query])
  end

  def cancel_params
    params.require(:booking).permit(Booking::CANCEL_PARAMS)
  end

  def find_bill
    @bill = Booking.find_by id: params[:id]
    return if @bill

    flash[:warning] = t("controllers.errors.bill_not_found")
    redirect_to admin_bills_path
  end
end
