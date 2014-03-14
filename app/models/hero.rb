class Hero < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
end
