class TourCategory < ApplicationRecord
  CREATE_PARAMS = [:category_name].freeze
  has_many :tours, dependent: :restrict_with_error

  validates :category_name, presence: true
  scope :new_category, ->{order(created_at: :desc)}
  scope :has_tour, -> {joins(:tours).distinct }
end
