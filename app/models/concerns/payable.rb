module Payable
  extend ActiveSupport::Concern

  PAYMENT_SERVICES = {
    sber_bank: {
      client: PaymentClient::SberBank,
      currency: "RUB"
    },
    euro_bank: {
      client: PaymentClient::EuroBank,
      currency: "EUR"
    },
    us_bank: {
      client: PaymentClient::USBank,
      currency: "USD"
    }
  }.freeze

  included do
    belongs_to :order

    validates :payment_service_name, inclusion: PAYMENT_SERVICES.stringify_keys.keys
    validates :currency, inclusion: Payment::CURRENCIES
    validates :amount, presence: true, numericality: { greater_than: 0 }
    validates :order_id, presence: true

    def find_payment_service_by_currency
      PAYMENT_SERVICES.select { |_, v| v[:currency] == currency }
    end

    def confirm!
      service = find_payment_service_by_currency

      unless find_payment_service_by_currency
        raise "We do not support payment in this currency"
      end

      service[:client].process_payment(self)
    end
  end
end