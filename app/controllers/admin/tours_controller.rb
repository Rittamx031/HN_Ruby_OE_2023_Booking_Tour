class Admin::ToursController < Admin::BaseController
  before_action :find_tour, only: %i(show edit update destroy)

  def index
    @pagy, @tours = pagy(Tour.new_tour, items: Settings.tours_on_page)
  end

  def show; end

  def edit; end

  def update
    if @tour.update(tour_params)
      flash[:success] = t("tourcontroller.flash_messages.edit_success")
      redirect_to admin_tour_path(@tour)
    else
      flash[:danger] = t("tourcontroller.flash_messages.edit_failure")
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @tour = Tour.new(tour_params)
    if @tour.save
      flash[:success] = t("tourcontroller.flash_messages.create_success")
      redirect_to admin_tour_path(@tour)
    else
      flash[:danger] = t("tourcontroller.flash_messages.create_failure")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @tour.destroy
      flash[:success] = t("tourcontroller.flash_messages.deleted_success")
      redirect_to admin_tours_path
    else
      flash[:danger] = t("tourcontroller.flash_messages.deleted_failure")
      redirect_to admin_tour_path(@tour)
    end
  end

  def new
    @tour = Tour.new
  end

  private

  def tour_params
    params.require(:tour).permit(Tour::CREATE_PARAMS)
  end

  def find_tour
    @tour = Tour.friendly.find params[:id]
    return if @tour

    flash[:success] = t("tour_details.message.not_found")
    redirect_to admin_tours_path
  end
end
