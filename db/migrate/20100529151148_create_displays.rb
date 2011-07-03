class CreateDisplays < ActiveRecord::Migration
  def self.up
    create_table :displays do |t|
      t.string :product_id
      t.string :display_type
      t.datetime :expiry

      t.timestamps
    end
  end

  def self.down
    drop_table :displays
  end
end
