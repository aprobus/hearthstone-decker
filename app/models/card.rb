class Card < ActiveRecord::Base
  validates :name, :presence => true
  validates :card_type, :inclusion => { :in => ['minion', 'weapon', 'spell']}
  validates :mana, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  belongs_to :hero
end
