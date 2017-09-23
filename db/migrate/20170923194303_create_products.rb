class CreateProducts < ActiveRecord::Migration[5.1]
  def up
    create_table :products do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.decimal :price, precision: 8, scale: 2, null: false

      t.timestamps
    end

    add_index(:products, :code, unique: true)
  end

  def down
    remove_index(:products, :code)
    drop_table(:products)
  end
end
