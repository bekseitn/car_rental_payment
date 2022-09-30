class Car < ApplicationRecord
  validates :name, presence: true
  validates :currency, inclusion: Payment::AVAILABLE_CURRENCIES
  validates :price_per_day, numericality: { greater_than: 0 }
end
