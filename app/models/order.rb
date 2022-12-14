# The main class that combines user and rental car data.
# Payment and refunds are process for this instance of the object.
class Order < ApplicationRecord
  enum status: {
    pending: 0,
    cancelled: 1,
    completed: 2,
    reversed: 3
  }

  belongs_to :user
  belongs_to :car

  has_many :payment_refunds
  has_many :payment_requests

  validates :user, :car, :status, presence: true

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
    total_paid < car.price_per_day
  end

  def currency
    car.currency
  end
end
