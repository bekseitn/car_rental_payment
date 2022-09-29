module Payable
  extend ActiveSupport::Concern

  PAYMENT_SERVICES = {
    sber_bank: PaymentClien::SberBank,
    euro_bank: PaymentClien::EuroBank
  }.freeze

  included do
    validates :payment_service_name, inclusion: PAYMENT_SERVICES.stringify_keys.keys
    validates :currency, inclusion: Payment::CURRENCIES
    validates :amount, presence: true, numericality: { greater_than: 0 }
  end
end