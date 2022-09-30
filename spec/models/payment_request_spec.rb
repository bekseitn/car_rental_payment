require "rails_helper"

RSpec.describe PaymentRequest, type: :model do
  let(:user) { create(:user) }
  let(:car) { create(:car, currency: "USD", price_per_day: 100) }
  let(:order) { create(:order, user: user, car: car) }

  context "payment request" do
    it "can pay deposit with order currency" do
      PaymentRequest.create(order: order, currency: "USD", amount: 30, status: "pending")
      PaymentRequest.create(order: order, currency: "USD", amount: 40, status: "pending")

      order.payment_requests.each(&:confirm!)
      order.reload

      order.payment_requests.each do |payment_request|
        expect(payment_request.status).to eq("success")
      end

      expect(order.total_paid).to eq(70)
      expect(order.has_debt?).to be_truthy

      # can't pay more than the car rental price_per_day
      payment_request = PaymentRequest.new(order: order, currency: "USD", amount: 100, status: "pending")
      expect(payment_request.valid?).to be_falsey
    end

    it "can pay deposit with multiple currency" do
      PaymentRequest.create(order: order, currency: "USD", amount: 30, status: "pending")
      PaymentRequest.create(order: order, currency: "CAD", amount: 10, status: "pending")
      PaymentRefund.create(order: order, currency: "GBP", amount: 10, status: "pending")

      order.payment_requests.each(&:confirm!)
      order.reload

      order.payment_requests.each do |payment_request|
        expect(payment_request.status).to eq("success")
      end

      expect(order.total_paid).not_to eq(40)
      expect(order.total_paid).to eq(order.payment_requests_sum)
      expect(order.has_debt?).to be_truthy
    end

    it "can't pay more than user paid before" do
      PaymentRequest.create(order: order, currency: "USD", amount: 100, status: "success")
      payment_request = PaymentRequest.new(order: order, currency: "CAD", amount: 100, status: "pending")
      expect(payment_request.valid?).to be_falsey
    end
  end
end
