class PaymentRequest < Payment
  validate :deposit_amount_limit

  private

  def deposit_amount_limit
    if order.total_paid + amount_in_order_currency > order.car.price_per_day
      errors.add(:amount, "Deposit amount should be less than order price_per_day")
    end
  end
end
