class AddNameToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :name, :string
  end

  def self.down
    remove_column :companies, :name
  end
end
