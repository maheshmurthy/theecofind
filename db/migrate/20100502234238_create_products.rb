class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.integer :company_id
      t.string :name
      t.float :price
      t.string :image
      t.string :link

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
