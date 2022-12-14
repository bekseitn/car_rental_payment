# Model for pay order. The user can pay with several deposits in different currencies.
# The amount of all deposits cannot exceed the price of the order.
class PaymentRequest < Payment
  validate :deposit_amount_limit

  def confirm!
    payment_client.new(self, "request").process_payment
  end

  private

  def deposit_amount_limit
    if order.total_paid + amount_in_order_currency > order.car.price_per_day
      errors.add(:amount, "Deposit amount should be less than order price_per_day")
    end
  end
end
