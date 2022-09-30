class Car < ApplicationRecord
  validates :name, presence: true
  validates :currency, inclusion: Payable::CURRENCIES
  validates :price_per_day, numericality: { greater_than: 0 }
end
