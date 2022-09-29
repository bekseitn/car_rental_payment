class User < ApplicationRecord
  validates :phone, presence: true
end
