class Payment::Refund < ApplicationRecord
  include Payable

  validate :refund_amount

  private

  def refund_amount
    if amount > order.paid_amount
      errors.add(:amount, "Refund amount should be less or equal than paids sum for order")
    end
  end
end
