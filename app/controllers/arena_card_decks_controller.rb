require 'num_decks_stat'
require 'avg_wins_stat'

class ArenaCardDecksController < CardDecksBaseController

  def controller_model
    ArenaCardDeck
  end

  def stats
    arena_card_decks = ArenaCardDeck.completed.where(:user_id => current_user.id)

    @num_decks = DeckStats::NumDecksStat.new(arena_card_decks)
    @avg_wins = DeckStats::AvgWinsStat.new(arena_card_decks)
  end

end

