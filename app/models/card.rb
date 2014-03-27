class Card < ActiveRecord::Base
  validates :name, :presence => true
  validates :card_type, :inclusion => { :in => ['minion', 'weapon', 'spell']}
  validates :rarity, :inclusion => { :in => ['soul_bound', 'common', 'rare', 'epic', 'legendary']}
  validates :mana, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validates :damage, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 , :allow_blank => true}

  belongs_to :hero

end

