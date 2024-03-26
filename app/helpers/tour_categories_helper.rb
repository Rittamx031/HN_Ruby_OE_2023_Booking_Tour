module TourCategoriesHelper
  def categories
    TourCategory.all
  end
  def categories_has_tour
    TourCategory.has_tour
  end
end
