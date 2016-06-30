class CreateSaleEvents < ActiveRecord::Migration
  def change
    create_table :spree_sale_events do |t|
      t.string :name
      t.text :description
      t.string :permalink
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.boolean :is_active
      t.boolean :is_hidden
      t.boolean :is_permanent
      t.integer :discount_percentage
      t.integer :position, default: 0
      t.integer :active_sale_id
      t.integer :product_id

      t.timestamps null: false
    end

    add_index :spree_sale_events, [:active_sale_id], :name => 'index_active_sale_on_active_sale_id'
    add_index :spree_sale_events, [:product_id], :name => 'index_active_sale_on_product_id'
    add_index :spree_sale_events, [:permalink], :name => 'index_active_sale_on_permalink'
  end
end
