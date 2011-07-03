class Display < ActiveRecord::Base
  belongs_to :product
  named_scope :unexpired, :conditions => ['expiry > ?', Time.now]
end
