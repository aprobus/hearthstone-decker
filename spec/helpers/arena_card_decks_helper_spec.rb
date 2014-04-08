require 'spec_helper'

describe ArenaCardDecksHelper do

  describe '#hero_name' do
    it 'should work for models with hero_id attribute' do
      deck = ArenaCardDeck.new(:hero => Hero.find_by_name(:shaman))
      result = hero_name(deck)
      expect(result).to eq('Shaman')
    end

    it 'should work for heroes' do
      shaman = Hero.find_by_name(:shaman)
      result = hero_name(shaman)
      expect(result).to eq('Shaman')
    end
  end
end

