class Car < ApplicationRecord
  validates :name, presence: true
  validates :currency, inclusion: Money::Currency.map(&:iso_code)
  validates :price_per_day, numericality: { greater_than: 0 }
end
