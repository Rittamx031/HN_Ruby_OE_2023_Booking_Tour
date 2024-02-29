class BookingMailer < ApplicationMailer
  def cancel_booking
    @user = params[:user]
    @booking = params[:booking]
    mail(to: @user.email, subject: I18n.t("bookings.mail.cancel_title"))
  end

  def confirm_booking
    @user = params[:user]
    @booking = params[:booking]
    mail(to: @user.email, subject: I18n.t("bookings.mail.confirm_title"))
  end
end
