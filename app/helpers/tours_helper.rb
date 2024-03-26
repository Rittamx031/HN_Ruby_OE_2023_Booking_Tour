module ToursHelper
  def default_image tour
    tour.image&.attached? ? tour.image : Settings.default_image_tour
  end
end
