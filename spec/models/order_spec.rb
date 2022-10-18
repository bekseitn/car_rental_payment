require "rails_helper"

RSpec.describe Order, type: :model do
  let(:user) { create(:user) }
  let(:car) { create(:car, currency: "USD") }

  context "create order" do
    it "is valid?" do
      order = Order.new(user: user, car: car, status: "pending")
      expect(order).to be_valid
    end

    it "with invalid status" do
      expect { Order.new(user: user, car: car, status: "testing") }
        .to raise_error(ArgumentError)
        .with_message(/is not a valid status/)
    end
  end
end
