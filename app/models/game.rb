class Game < ActiveRecord::Base

  MODES = ['ranked', 'arena', 'normal']

  validates :user, :presence => true
  validates :card_deck, :presence => true
  validates :hero, :presence => true
  validates :mode, :inclusion => { :within => MODES, :message => '%{value} is not a valid game mode' }

  belongs_to :user
  belongs_to :card_deck
  belongs_to :hero

end
