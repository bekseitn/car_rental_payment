require "rails_helper"

RSpec.describe Payment::Refund, type: :model do
  let(:user) { create(:user) }
  let(:car) { create(:car, currency: "USD", price: 100) }
  let(:order) { create(:order, user: user, car: car) }

  context "init payment refund" do
    it "refund deposit with order currency" do
      Payment::Request.create(order: order, currency: "USD", amount: 100, status: "success")

      Payment::Refund.create(order: order, currency: "USD", amount: 30, status: "pending")
      Payment::Refund.create(order: order, currency: "USD", amount: 10, status: "pending")

      order.payment_refunds.each(&:confirm!)
      order.reload

      order.payment_refunds.each do |payment_refund|
        expect(payment_refund.status).to eq("success")
      end

      expect(order.total_paid).to eq(60)
      expect(order.has_debt?).to be_truthy

      # can't pay more than user paid before
      payment_refund = Payment::Refund.new(order: order, currency: "USD", amount: 100, status: "pending")
      expect(payment_refund.valid?).to be_falsey
    end

    it "pay deposit with multiple currency" do
      Payment::Request.create(order: order, currency: "USD", amount: 100, status: "success")

      usd_refund = Payment::Refund.create(order: order, currency: "USD", amount: 30, status: "pending")
      eu_refund = Payment::Refund.create(order: order, currency: "CAD", amount: 10, status: "pending")

      order.payment_refunds.each(&:confirm!)
      order.reload

      order.payment_refunds.each do |payment_refund|
        expect(payment_refund.status).to eq("success")
      end

      expect(order.total_paid).to eq(100 - usd_refund.amount_in_order_currency - eu_refund.amount_in_order_currency)
      expect(order.has_debt?).to be_truthy

      # can't pay more than user paid before
      payment_refund = Payment::Refund.new(order: order, currency: "CAD", amount: 100, status: "pending")
      expect(payment_refund.valid?).to be_falsey
    end
  end
end
