class ApplicationController < ActionController::Base
  include Pagy::Backend
  include ToursHelper
  include ReviewsHelper
  include TourCategoriesHelper
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def check_user
    if !check_login?
      redirect_to login_path
    elsif not_user_role?
      redirect_to admin_dashboard_path
    end
  end

  def check_login?
    unless user_signed_in?
      flash[:danger] = t("controllers.errors.required_login")
    end
    user_signed_in?
  end

  def not_user_role?
    if current_user.admin?
      flash[:danger] = t("controllers.errors.only_user_role")
    end
    current_user.admin?
  end

  def build_message object, default_message
    return default_message if object.errors.empty?

    " #{object.errors.full_messages.join(', ')}"
  end

  protected

  def configure_permitted_parameters
    added_attrs = User::SIGNUP_PARAMS
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
