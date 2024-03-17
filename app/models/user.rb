class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i(google_oauth2)

  SIGNUP_PARAMS = [:username, :phone, :email,
                  :password, :avatar,
                  :password_confirmation].freeze

  has_many :bookings, dependent: :nullify
  has_one_attached :avatar do |attachable|
    attachable.variant :avatar_icon,
                       resize_to_limit: [Settings.high_avatar_icon,
                                         Settings.width_avatar_icon]
  end
  has_many :reviews, through: :bookings, source: :review
  has_many :tour_followings, dependent: :destroy
  has_many :followed_tours, through: :tour_followings, source: :tour
  validates :email, presence: true
  validates :username, presence: true
  validates :phone, presence: true, allow_nil: true
  validates :password, presence: true, allow_nil: true
  validates :password_confirmation, presence: true, allow_nil: true
  scope :new_user, ->{order(created_at: :desc)}
  class << self
    def from_omniauth auth
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provide
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.username = auth.info.name
      end
    end
  end
  def following_tour tour
    raise I18n.t("tours.follow_exit") if followed_tours.include?(tour)

    raise I18n.t("tours.follow_unsuccess") unless followed_tours << tour
  end

  def unfollow_tour tour
    raise I18n.t("tours.follow_not_exit") unless  followed_tours.include?(tour)

    raise I18n.t("tours.unfollow_unsuccess") unless followed_tours.delete(tour)
  end
end
