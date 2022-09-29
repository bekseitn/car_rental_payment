require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { create(:user) }
  let(:car) { create(:car, currency: "USD") }

  context 'create order' do
    it 'is valid?' do
      order = Order.new(user: user, car: car, status: "pending")
      expect(order.valid?).to be_truthy
    end
  end
end
