module Payment
  CURRENCIES = %w{ dollar euro ruble }.freeze

  def self.table_name_prefix
    "payment_"
  end
end
