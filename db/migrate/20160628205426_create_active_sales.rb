class CreateActiveSales < ActiveRecord::Migration
  def change
    create_table :spree_active_sales do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
