class CreateCars < ActiveRecord::Migration[7.0]
  def change
    create_table :cars do |t|
      t.string :name
      t.decimal :price_per_day, null: false, precision: 10, scale: 2
      t.string :currency, null: false

      t.timestamps
    end
  end
end
