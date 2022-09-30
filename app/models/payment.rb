# Parent class for payment requests and redunds.
# Keep the logic of searching the payment system for the selected currency and converting amount into the currency of the order.
class Payment < ApplicationRecord
  PAYMENT_SERVICES = {
    uk_bank: {
      client: PaymentClient::UKBank,
      currency: "GBP"
    },
    canada_bank: {
      client: PaymentClient::CanadaBank,
      currency: "CAD"
    },
    us_bank: {
      client: PaymentClient::USBank,
      currency: "USD"
    }
  }.with_indifferent_access.freeze

  PAYMENT_STATUSES = %w[pending success fail].freeze
  AVAILABLE_CURRENCIES = %w[USD CAD GBR].freeze

  belongs_to :order

  scope :completed, ->{ where(status: "success") }
  scope :failed, ->{ where(status: "fail") }

  before_validation :set_payment_service_name

  validates :payment_service_name, inclusion: PAYMENT_SERVICES.keys
  validates :currency, inclusion: AVAILABLE_CURRENCIES
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, allow_blank: true, inclusion: PAYMENT_STATUSES
  validates :order_id, presence: true

  def payment_client
    @service ||= PAYMENT_SERVICES[payment_service_name][:client]
  end

  def amount_in_order_currency
    return amount if currency == order.currency

    convert_to_order_currency
  end

  def convert_to_order_currency
    eu_bank = EuCentralBank.new

    # call this before calculating exchange rates
    # this will download the rates from ECB
    # TODO move to controller and run only once before calculating currency difference
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
