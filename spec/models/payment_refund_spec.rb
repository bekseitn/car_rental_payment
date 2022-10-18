require "rails_helper"

RSpec.describe PaymentRefund, type: :model do
  let(:user) { create(:user) }
  let(:car) { create(:car, currency: "USD", price_per_day: 100) }
  let(:order) { create(:order, user: user, car: car) }

  context "payment refund" do
    it "return part of the paid sum in the same currency" do
      PaymentRequest.create(order: order, currency: "USD", amount: 100, status: "completed")

      PaymentRefund.create(order: order, currency: "USD", amount: 30, status: "pending")
      PaymentRefund.create(order: order, currency: "USD", amount: 10, status: "pending")

      order.payment_refunds.each(&:confirm!)
      order.reload

      order.payment_refunds.each do |payment_refund|
        expect(payment_refund.status).to eq("completed")
      end

      expect(order.total_paid).to eq(60)
      expect(order.has_debt?).to be_truthy

      # can't pay more than user paid before
      payment_refund = PaymentRefund.new(order: order, currency: "USD", amount: 100, status: "pending")
      expect(payment_refund.valid?).to be_falsey
    end

    it "return part of the paid sum in another currency" do
      PaymentRequest.create(order: order, currency: "USD", amount: 100, status: "completed")

      PaymentRefund.create(order: order, currency: "USD", amount: 30, status: "pending")
      PaymentRefund.create(order: order, currency: "CAD", amount: 10, status: "pending")
      PaymentRefund.create(order: order, currency: "GBP", amount: 10, status: "pending")

      order.payment_refunds.each(&:confirm!)
      order.reload

      order.payment_refunds.each do |payment_refund|
        expect(payment_refund.status).to eq("completed")
      end

      expect(order.total_paid).to eq(100 - order.payment_refunds_sum)
      expect(order.has_debt?).to be_truthy
    end

    it "can't pay more than user paid before" do
      PaymentRequest.create(order: order, currency: "USD", amount: 100, status: "completed")
      payment_refund = PaymentRefund.new(order: order, currency: "CAD", amount: 1000, status: "pending")
      expect(payment_refund.valid?).to be_falsey
    end
  end
end
