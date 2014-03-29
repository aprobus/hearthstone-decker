class CardDeck < ActiveRecord::Base

  validates :user, :presence => true
  validates :hero, :presence => true
  validates :num_games_lost, numericality: { only_integer: true, :greater_than_or_equal_to => 0 }
  validates :num_games_won, numericality: { only_integer: true, :greater_than_or_equal_to => 0 }

  belongs_to :hero
  belongs_to :user
  has_and_belongs_to_many :cards, :before_add => :limit_number_of_cards
  has_many :games, :dependent => :destroy

  grant(:create, :find, :update, :destroy) { |user, model, action| !user.nil? && model.user_id == user.id }

  def limit_number_of_cards(added_card)
    raise Exception.new('Card limit for the deck reached') if cards.size >= 30

    before_card_added(added_card)
  end

  def before_card_added(added_card)

  end

  def num_games_total
    num_games_lost + num_games_won
  end

  def add_games?
    true
  end

  def add_game
    game = Game.new
    game.card_deck = self
    yield game

    CardDeck.transaction do
      if !game.save
        raise ActiveRecord::Rollback.new
      end

      if game.win_ind
        num_wins = self.num_games_won || 0
        self.num_games_won = num_wins + 1
      else
        num_losses = self.num_games_lost || 0
        self.num_games_lost = num_losses + 1
      end

      if !self.save
        #Should never get here
        raise ActiveRecord::Rollback.new
      end
    end

    game
  end

  def delete_game(game)
    if game.win_ind
      self.num_games_won = self.num_games_won - 1
    else
      self.num_games_lost = self.num_games_lost - 1
    end

    CardDeck.transaction do
      self.save!
      game.destroy
    end
  end

  def win_rate
    if num_games_total <= 0
      0.0
    else
      num_games_won.to_f / num_games_total.to_f * 100.0
    end
  end

end
