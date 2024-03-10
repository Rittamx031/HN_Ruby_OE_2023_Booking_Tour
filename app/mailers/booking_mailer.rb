class BookingMailer < ApplicationMailer
  def cancel_booking
    @user = params[:user]
    @booking = params[:booking]
    mail(to: @user.email, subject: t("bookings.mail.cancel_title"))
  end

  def confirm_booking
    @user = params[:user]
    @booking = params[:booking]
    mail(to: @user.email, subject: t("bookings.mail.confirm_title"))
  end

  def successed_booking
    @user = params[:user]
    @booking = params[:booking]
    mail(to: @user.email, subject: t("bookings.mail.successed_title"))
  end
end
