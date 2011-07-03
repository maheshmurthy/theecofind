# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
["garden", "bathroom", "cleaning_supplies", "kitchen", "bags", "clothing", "lighting", "office_supplies", "sports_and_outdoors", "shoes"].each do |tag|
  Tag.find_or_create_by_name(tag)
end

product_type_tag = {
  "clothing" => ["shirt", "hoodie", "sweatshirt", "sleeve", "fleece", "hoody"],
  "lighting" => ["bulb", "watt", "cfl", "light", "adaptor", "candelabra", "adapter", "socket", "volt", "energy", "surge", "charger"],
  "kitchen" => ["pot", "spoon", "tongs", "container", "cupcake", "refrigerator", "dish", "sponge", "scrubby", "towels", "apron", "apron-", "refrigerator", "cup"],
  "bags" => ["bag", "clutch", "bags"],
  "office_supplies" => ["stapler", "cartridge", "paper"],
  "sports_and_outdoors" => ["bottle"],
  "shoes" => ["flip flop", "sneaker", "sneakers", "shoelaces", "shoes"],
  "garden" => ["lawn"],
  "bathroom" => ["bathroom", "showerhead", "toothbrushes", "toothbrush"],
  "cleaning_supplies" => ["detergent"]
}

product_type_tag.each do |tag, items|
  t = Tag.find_by_name(tag)
  items.each do |item|
    ProductTypeTag.find_or_create_by_product_type_and_tag_id(:product_type => item, :tag_id => t.id)
  end
end
