class CardDeck < ActiveRecord::Base

  validates :user, :presence => true
  validates :hero, :presence => true
  validates :name, :length => { :maximum => 64 }, :presence => true

  belongs_to :hero
  belongs_to :user

end
