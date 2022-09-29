class Payment::Request < ApplicationRecord
  include Payable

  validate :deposit_amount_limit

  private

  def deposit_amount_limit
    if order.total_paid + amount_in_order_currency > order.car.price
      errors.add(:amount, "Deposit amount should be less than order price")
    end
  end
end
