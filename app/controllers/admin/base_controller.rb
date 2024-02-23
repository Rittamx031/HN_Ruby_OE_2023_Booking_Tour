class Admin::BaseController < ApplicationController
  layout "admin/layouts/admin_layout"
  before_action :authenticate_user!
  before_action :check_admin
  private

  def check_admin
    return if current_user.admin?
    flash[:warning] = t("controllers.errors.only_admin_role")
    redirect_to login_url
  end
end
