class CreateOperations < ActiveRecord::Migration[7.0]
  def change
    create_table :operations do |t|
      t.decimal :amount
      t.string :description
      t.integer :otype
      t.datetime :odate
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end