class Car < ApplicationRecord
  validates :name, presence: true
  validates :currency, inclusion: Payment::CURRENCIES
  validates :price, numericality: { greater_than: 0 }
end
