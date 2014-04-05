class Game < ActiveRecord::Base

  MODES = ['ranked', 'arena', 'normal']

  validates :user, :presence => true
  validates :card_deck, :presence => true
  validates :hero, :presence => true
  validates :mode, :inclusion => { :within => MODES, :message => '%{value} is not a valid game mode' }
  validate :check_deck_type
  validate :can_add_games_to_deck
  validate :owner_also_owns_deck

  belongs_to :user
  belongs_to :card_deck
  belongs_to :hero
  belongs_to :game_import

  grant(:create, :find, :update, :destroy) { |user, model, action| !user.nil? && model.user_id == user.id }

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

  def can_add_games_to_deck
    if card_deck && !card_deck.add_games?
      errors[:base] << 'Cannot add games to this deck'
    end
  end

  def owner_also_owns_deck
    if user_id && card_deck && user_id != card_deck.user_id
      errors[:card_deck] << 'You are not the owner of this card deck'
    end
  end

end
