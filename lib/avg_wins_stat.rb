module DeckStats
  class AvgWinsStat
    def initialize(decks)
      @decks = decks
    end

    def by_hero
      arena_decks_by_hero = @decks.group_by{|deck| deck.hero_id }

      return Hero.all.map do |hero|
        avg_wins = avg_num_wins_for_decks(arena_decks_by_hero[hero.id] || []) 
        { :hero => hero, :value => avg_wins }
      end
    end

    def total
      avg_num_wins_for_decks(@decks)
    end

    private 
    
    def avg_num_wins_for_decks(decks)
      total_wins = decks.reduce(0){|sum, deck| sum + deck.num_games_won }
      total_runs = [1, decks.length].max
      total_wins.to_f / total_runs.to_f
    end
  end
end

