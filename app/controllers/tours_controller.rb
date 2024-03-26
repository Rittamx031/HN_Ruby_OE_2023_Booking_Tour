class ToursController < ApplicationController
  before_action :set_tour, only: %i(show)
  before_action :set_tour_category, only: %i(tour_category)
  before_action :ransack_params
  before_action :check_user, only: %i(following_tour)
  def index
    @pagy, @tours = pagy(@q.result(distinct: true))
  end

  def show
    @pagy, @reviews = pagy(@tour.reviews.new_review)
  end

  def tour_category
    @pagy, @tours = pagy(Tour.tour_in_category  @tour_category.id)
    render :index
  end

  def following_tour
    @pagy, @tours = pagy(current_user.followed_tours)
    render :index
  end

  private

  def set_tour
    @tour = Tour.friendly.find params[:id]
    return if @tour

    flash[:success] = t("tour_details.message.not_found")
    redirect_to admin_tours_path
  end

  def set_tour_category
    @tour_category = TourCategory.find params[:tour_category_id]
    return if @tour_category

    flash[:success] = t("tour_details.message.not_found")
    redirect_to admin_tours_path
  end

  def ransack_params
    @q = Tour.ransack(params[:query])
  end
end
