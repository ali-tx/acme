class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :basket, null: false, foreign_key: true
      t.decimal :total
      t.string :status

      t.timestamps
    end
  end
end
