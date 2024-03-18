require 'rails_helper'

RSpec.describe User, type: :model do

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:password_confirmation).allow_nil }
    it { should validate_presence_of(:phone).allow_nil }
  end

  describe "associations" do
    it { should have_many(:bookings).dependent(:nullify) }
    it { should have_many(:reviews).through(:bookings).source(:review) }
    it { should have_many(:tour_followings).dependent(:destroy) }
    it { should have_many(:followed_tours).through(:tour_followings).source(:tour) }
  end
  describe "scopes" do
    it "orders users by creation date in descending order" do
      new_user1 = FactoryBot.create(:user)
      new_user2 = FactoryBot.create(:user)
      expect(User.new_user).to eq([new_user2, new_user1])
    end
    it "users_signup" do
        create(:user, created_at: 2.days.ago + 1.hours)
        create(:user, created_at: 1.day.ago + 1.hours)
        create(:user, created_at: Time.zone.now)
        result = User.users_signup(2.days.ago, Time.zone.now)
        expect(result).to eq({2.days.ago.strftime(Settings.dd_mm_yyyy_fm) => 1,
                              1.days.ago.strftime(Settings.dd_mm_yyyy_fm) => 1,
                              Time.zone.now.strftime(Settings.dd_mm_yyyy_fm) => 1})
    end
  end

  it "registratrion user valid " do
    user = FactoryBot.create(:user)
    expect(user.save).to be true
  end

  describe "#following_tour" do
    let(:user) { FactoryBot.create(:user) }
    let(:tour) { FactoryBot.create(:tour) }

    it "allows user to follow a tour" do
      expect {
        user.following_tour(tour)
      }.to change(user.followed_tours, :count).by(1)
    end

    it "raises error if user tries to follow the same tour again" do
      user.following_tour(tour)
      expect { user.following_tour(tour) }.to raise_error(I18n.t("tours.follow_exit"))
    end
  end

  describe "#unfollow_tour" do
    let(:user) { FactoryBot.create(:user) }
    let(:tour) { FactoryBot.create(:tour) }

    it "allows user to unfollow a tour" do
      user.following_tour(tour)
      expect {
        user.unfollow_tour(tour)
      }.to change(user.followed_tours, :count).by(-1)
    end

    it "raises error if user tries to unfollow a tour that is not being followed" do
      expect { user.unfollow_tour(tour) }.to raise_error(I18n.t("tours.follow_not_exit"))
    end
  end

end
