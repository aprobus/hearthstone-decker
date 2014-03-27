module DeckStats
  class NumDecksStat
    def initialize(decks)
      @decks = decks
    end

    def by_hero
      arena_decks_by_hero = @decks.group_by{|deck| deck.hero_id }
      return Hero.all.map do |hero|
        num_decks = (arena_decks_by_hero[hero.id] || []).size
        { :hero => hero, :value => num_decks }
      end
    end

    def total
      @decks.size
    end
  end
end

