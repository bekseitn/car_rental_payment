module Payable
  extend ActiveSupport::Concern

  PAYMENT_SERVICES = {
    sber_bank: {
      client: PaymentClient::SberBank,
      currency: "RUB"
    },
    euro_bank: {
      client: PaymentClient::EuroBank,
      currency: "CAD"
    },
    us_bank: {
      client: PaymentClient::UsBank,
      currency: "USD"
    }
  }.with_indifferent_access.freeze

  CURRENCIES = %w[USD CAD RUB].freeze
  PAYMENT_STATUSES = %w[pending success fail].freeze

  included do
    belongs_to :order

    scope :completed, ->{ where(status: "success") }
    scope :failer, ->{ where(status: "fail") }

    before_validation :set_payment_service_name

    validates :payment_service_name, inclusion: PAYMENT_SERVICES.stringify_keys.keys
    validates :currency, inclusion: CURRENCIES
    validates :amount, presence: true, numericality: { greater_than: 0 }
    validates :status, allow_blank: true, inclusion: PAYMENT_STATUSES
    validates :order_id, presence: true
  end

  def confirm!
    service = PAYMENT_SERVICES[payment_service_name]
    service[:client].new(self).process_payment
  end

  def amount_in_order_currency
    return amount if currency == order.currency

    convert_to_order_currency
  end

  def convert_to_order_currency
    eu_bank = EuCentralBank.new

    # call this before calculating exchange rates
    # this will download the rates from ECB
    eu_bank.update_rates

    eu_bank.exchange(amount, currency, order.currency).cents
  end

  private

  def set_payment_service_name
    service_name = PAYMENT_SERVICES.find { |_, v| v[:currency] == currency }&.first
    raise "We do not support payment in this currency" unless service_name

    self.payment_service_name = service_name
  end
end