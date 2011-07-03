class CreateProductTypeTags < ActiveRecord::Migration
  def self.up
    create_table :product_type_tags do |t|
      t.string :product_type
      t.integer :tag_id

      t.timestamps
    end
  end

  def self.down
    drop_table :product_type_tags
  end
end
