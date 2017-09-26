class CreateDiscountStrategies < ActiveRecord::Migration[5.1]
  def up
    create_table(:discount_strategies) do |t|
      t.string :code, null: false
      t.string :type, null: false
      t.jsonb :options, default: {}
    end

    add_index(:discount_strategies, :code, unique: true)
  end

  def down
    remove_index(:discount_strategies, :code)
    drop_table(:discount_strategies)
  end
end
