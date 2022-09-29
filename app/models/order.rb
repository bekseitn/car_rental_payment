class Order < ApplicationRecord
  STATUSES = %w{ pending cancelled completed reversed }.freeze

  belongs_to :user
  belongs_to :car

  has_many :payment_refunds, class_name: 'Payment::Refund'
  has_many :payment_requests, class_name: 'Payment::Request'

  validates :user, :car, :status, presence: true
  validates :status, inclusion: STATUSES

  def paid_amount
    payment_requests.sum(:amount_in_order_currency)
  end

  def has_debt?
    paid_amount < car.price
  end
end
