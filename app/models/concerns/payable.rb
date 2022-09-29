module Payable
  extend ActiveSupport::Concern

  PAYMENT_SERVICES = {
    sber_bank: PaymentClient::SberBank,
    euro_bank: PaymentClient::EuroBank
  }.freeze

  included do
    belongs_to :order

    validates :payment_service_name, inclusion: PAYMENT_SERVICES.stringify_keys.keys
    validates :currency, inclusion: Payment::CURRENCIES
    validates :amount, presence: true, numericality: { greater_than: 0 }
    validates :order_id, presence: true
  end
end