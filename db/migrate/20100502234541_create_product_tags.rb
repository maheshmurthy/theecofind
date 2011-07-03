class CreateProductTags < ActiveRecord::Migration
  def self.up
    create_table :product_tags do |t|
      t.integer :product_id
      t.integer :tag_id

      t.timestamps
    end
  end

  def self.down
    drop_table :product_tags
  end
end
