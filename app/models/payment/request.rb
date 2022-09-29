class Payment::Request < ApplicationRecord
  include Payable

  validate :deposit_amount

  def amount_in_order_currency
    return amount if currency == order.currency

    eu_bank = EuCentralBank.new

    # call this before calculating exchange rates
    # this will download the rates from ECB
    eu_bank.update_rates

    eu_bank.exchange(amount, currency, order.currency)
  end

  private

  def deposit_amount
    if order.paid_amount + amount_in_order_currency > order.price
      errors.add(:amount, "Deposit amount should be less than order price")
    end
  end
end
