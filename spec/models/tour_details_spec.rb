require 'rails_helper'

RSpec.describe TourDetail, type: :model do

  describe "associations" do
    it { should belong_to(:tour) }
    it { should have_many(:bookings).dependent(:destroy) }
    it { should have_many(:reviews).through(:bookings).source(:review) }
  end

  describe "validations" do
    it { should validate_presence_of(:detail_description) }
    it { should validate_presence_of(:tour_detail_name) }
    it { should validate_presence_of(:max_people) }
    it { should validate_numericality_of(:max_people).is_greater_than_or_equal_to(Settings.peoples_booking_min) }
    it { should validate_presence_of(:start_location) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(Settings.price_min) }
    it { should validate_presence_of(:time_duration) }
    it { should validate_numericality_of(:time_duration).is_greater_than_or_equal_to(Settings.time_during_min) }
  end
  describe "Create" do
    it "Create new tour details " do
      tour_detail = FactoryBot.create(:tour_detail)
      expect(tour_detail.save).to be true
    end
  end
  describe "update" do
    it "updates tour detail attributes" do
      tour_detail = create(:tour_detail)

      tour_detail.update(tour_detail_name: "New Name", detail_description: "New Description", max_people: 15, start_location: "New Location", price: 150, time_duration: 6)

      tour_detail.reload

      expect(tour_detail.tour_detail_name).to eq("New Name")
      expect(tour_detail.detail_description).to eq("New Description")
      expect(tour_detail.max_people).to eq(15)
      expect(tour_detail.start_location).to eq("New Location")
      expect(tour_detail.price).to eq(150)
      expect(tour_detail.time_duration).to eq(6)
    end
  end

  describe "delete" do
    it "deletes a tour detail" do
      tour_detail = create(:tour_detail)

      expect {
        tour_detail.destroy
      }.to change { TourDetail.count }.by(-1)
    end
  end
end
