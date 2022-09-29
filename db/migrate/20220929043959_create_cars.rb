class CreateCars < ActiveRecord::Migration[7.0]
  def change
    create_table :cars do |t|
      t.string :name
      t.float :price, null: false
      t.string :currency, null: false

      t.timestamps
    end
  end
end
