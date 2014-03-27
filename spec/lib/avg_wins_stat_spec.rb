require 'spec_helper'
require 'grant/spec_helpers'
require 'avg_wins_stat'

describe DeckStats::AvgWinsStat do
  include Grant::SpecHelpers

  before :all do
    @shaman = Hero.find_by_name(:shaman)
    @hunter = Hero.find_by_name(:hunter)
    @warlock = Hero.find_by_name(:warlock)
  end

  describe '#by_hero' do
    it 'should return correct value' do
      decks = []
      decks << FactoryGirl.create(:arena_card_deck, :num_games_won => 3, :num_games_lost => 3, :hero_id => @shaman.id) 
      decks << FactoryGirl.create(:arena_card_deck, :num_games_won => 3, :num_games_lost => 3, :hero_id => @shaman.id) 
      decks << FactoryGirl.create(:arena_card_deck, :num_games_won => 4, :num_games_lost => 3, :hero_id => @warlock.id) 
      decks << FactoryGirl.create(:arena_card_deck, :num_games_won => 4, :num_games_lost => 3, :hero_id => @warlock.id) 

      avg_wins = DeckStats::AvgWinsStat.new(decks)
      avg_wins_by_hero = avg_wins.by_hero

      expect(avg_wins_by_hero.find{|stat| stat[:hero] == @shaman}[:value]).to eq(3)
      expect(avg_wins_by_hero.find{|stat| stat[:hero] == @warlock}[:value]).to eq(4)
      expect(avg_wins_by_hero.find{|stat| stat[:hero] == @hunter}[:value]).to eq(0)
    end 
  end

  describe '#total' do
    it 'should find correct answer' do
      decks = []
      decks << FactoryGirl.create(:arena_card_deck, :num_games_won => 3, :num_games_lost => 3)       
      decks << FactoryGirl.create(:arena_card_deck, :num_games_won => 9, :num_games_lost => 3)       

      avg_wins = DeckStats::AvgWinsStat.new(decks)
      expect(avg_wins.total).to eq(6)
    end 

    it 'should avoid divide by 0 errors' do
      avg_wins = DeckStats::AvgWinsStat.new([])
      expect(avg_wins.total).to eq(0)
    end

  end
end

