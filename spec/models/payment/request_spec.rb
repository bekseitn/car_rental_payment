require "rails_helper"

RSpec.describe Payment::Request, type: :model do
  let(:user) { create(:user) }
  let(:car) { create(:car, currency: "USD", price: 100) }
  let(:order) { create(:order, user: user, car: car) }

  context "init payment request" do
    it "pay deposit with order currency" do
      Payment::Request.create(order: order, currency: "USD", amount: 30, status: "pending")
      Payment::Request.create(order: order, currency: "USD", amount: 40, status: "pending")

      order.payment_requests.each(&:confirm!)
      order.reload

      order.payment_requests.each do |payment_request|
        expect(payment_request.status).to eq("success")
      end

      expect(order.total_paid).to eq(70)
      expect(order.has_debt?).to be_truthy

      # can't pay more than the car rental price
      payment_request = Payment::Request.new(order: order, currency: "USD", amount: 100, status: "pending")
      expect(payment_request.valid?).to be_falsey
    end

    it "pay deposit with multiple currency" do
      usd_request = Payment::Request.create(order: order, currency: "USD", amount: 30, status: "pending")
      eu_request = Payment::Request.create(order: order, currency: "CAD", amount: 10, status: "pending")

      order.payment_requests.each(&:confirm!)
      order.reload

      order.payment_requests.each do |payment_request|
        expect(payment_request.status).to eq("success")
      end

      expect(order.total_paid).not_to eq(usd_request.amount + eu_request.amount)
      expect(order.total_paid).to eq(usd_request.amount_in_order_currency + eu_request.amount_in_order_currency)
      expect(order.has_debt?).to be_truthy

      # can't pay more than the car rental price
      payment_request = Payment::Request.new(order: order, currency: "CAD", amount: 100, status: "pending")
      expect(payment_request.valid?).to be_falsey
    end
  end
end
