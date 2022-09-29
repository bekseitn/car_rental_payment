class Order < ApplicationRecord
  STATUTES = %w{ new in_process success failure }.freeze

  belongs_to :user
  belongs_to :car

  validate :user, :car, :status, presence: true
  validate :status, inclusion: STATUTES
end
