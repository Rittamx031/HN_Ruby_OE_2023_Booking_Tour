class ToursController < ApplicationController
  before_action :set_tour, only: %i(show)

  def home; end

  def index
    @q = ransack_params
    @pagy, @tours = pagy(@q.result(distinct: true))
  end

  def show
    @pagy, @reviews = pagy(@tour.reviews.new_review)
  end

  private

  def set_tour
    @tour = Tour.friendly.find params[:id]
    return if @tour

    flash[:success] = t("tour_details.message.not_found")
    redirect_to admin_tours_path
  end

  def ransack_params
    Tour.ransack(params[:query])
  end
end
