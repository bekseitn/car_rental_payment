class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.decimal :amount, null: false
      t.string :currency, null: false
      t.string :payment_service_name, null: false
      t.string :type
      t.string :status
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
