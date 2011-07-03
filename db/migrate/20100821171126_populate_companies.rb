class PopulateCompanies < ActiveRecord::Migration
  def self.up
    Company.create(:name => 'autonomieproject', :website => 'http://www.autonomieproject.com')
    Company.create(:name => 'agreenerkitchen', :website => 'http://www.agreenerkitchen.com')
    Company.create(:name => 'bhappybags', :website => 'http://www.bhappybags.com')
    Company.create(:name => 'e3living', :website => 'http://www.e3living.com')
    Company.create(:name => 'plentyways', :website => 'http://www.plentyways.com')
  end

  def self.down
    Company.delete_all
  end
end
