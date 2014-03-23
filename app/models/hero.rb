class Hero < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true

  has_many :cards

  def display_name
    name.titleize
  end
end
