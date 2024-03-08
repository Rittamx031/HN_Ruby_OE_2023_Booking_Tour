class Tour < ApplicationRecord
  CREATE_PARAMS = [:tour_name, :hagtag,
                   :tour_description, :tour_category_id,
                   :image, :content].freeze
  extend FriendlyId
  friendly_id :tour_name, use: :slugged

  has_rich_text :content
  belongs_to :tour_category
  has_one_attached :image do |attachable|
    attachable.variant :tour_image,
                       resize_to_limit: [Settings.high_avatar_icon,
                       Settings.width_avatar_icon]
  end
  has_many :tour_details, dependent: :nullify
  has_many :bookings, through: :tour_details, source: :bookings
  has_many :tour_followings,
           class_name: TourFollowing.name, dependent: :destroy
  has_many :followed_users, through: :tour_followings,
            source: :user
  has_many :reviews, through: :tour_details,
           source: :reviews, class_name: Review.name
  validates :tour_name, presence: true
  validates :image, presence: true, allow_nil: true
  scope :new_tour, ->{order(created_at: :desc)}
end
