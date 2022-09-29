class AddStatusAndOrderIdToPayments < ActiveRecord::Migration[7.0]
  def change
    add_reference :payment_requests, :order
    add_reference :payment_refunds, :order

    add_column :payment_requests, :status, :string
    add_column :payment_refunds, :status, :string
  end
end
