module Payment
  CURRENCIES = %w{ USD EUR RUB }.freeze

  def self.table_name_prefix
    "payment_"
  end
end
