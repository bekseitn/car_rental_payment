module Payment
  CURRENCIES = %w{ USD EUR RUB }.freeze
  STATUSES = %w{ success fail }.freeze

  def self.table_name_prefix
    "payment_"
  end
end
