class Order < ApplicationRecord
  STATUSES = %w[pending cancelled completed reversed].freeze

  belongs_to :user
  belongs_to :car

  has_many :payment_refunds, class_name: "Payment::Refund"
  has_many :payment_requests, class_name: "Payment::Request"

  validates :user, :car, :status, presence: true
  validates :status, inclusion: STATUSES

  def total_paid
    payment_requests_sum - payment_refunds_sum
  end

  def payment_requests_sum
    payment_requests.completed.sum(&:amount_in_order_currency)
  end

  def payment_refunds_sum
    payment_refunds.completed.sum(&:amount_in_order_currency)
  end

  def has_debt?
    total_paid < car.price
  end

  def currency
    car.currency
  end
end
