class Game < ActiveRecord::Base

  MODES = ['ranked', 'arena', 'normal']

  validates :user, :presence => true
  validates :card_deck, :presence => true
  validates :hero, :presence => true
  validates :mode, :inclusion => { :within => MODES, :message => '%{value} is not a valid game mode' }
  validate :check_deck_type

  belongs_to :user
  belongs_to :card_deck
  belongs_to :hero

  def check_deck_type
    mode_to_deck_types = {
      'ranked' => RegularCardDeck,
      'normal' => RegularCardDeck,
      'arena' => ArenaCardDeck
    }

    if mode && card_deck && card_deck.class != mode_to_deck_types[mode]
      errors[:card_deck] << 'not a valid deck for game mode'
    end
  end

end
