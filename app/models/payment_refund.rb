class PaymentRefund < Payment
  validate :refund_amount_limit

  def confirm!
    payment_client.new(self, "refund").process_payment
  end

  private

  def refund_amount_limit
    if amount > order.total_paid
      errors.add(:amount, "Refund amount should be less or equal than paids sum for order")
    end
  end
end
