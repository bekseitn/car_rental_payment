class CreatePaymentRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_requests do |t|
      t.float :amount, null: false
      t.string :currency, null: false
      t.string :payment_service_name, null: false

      t.timestamps
    end
  end
end
