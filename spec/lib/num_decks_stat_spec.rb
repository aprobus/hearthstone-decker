require 'spec_helper'
require 'grant/spec_helpers'
require 'num_decks_stat'

describe DeckStats::NumDecksStat do
  include Grant::SpecHelpers

  before :all do
    @user = User.first

    @shaman = Hero.find_by_name(:shaman)
    @hunter = Hero.find_by_name(:hunter)
    @warlock = Hero.find_by_name(:warlock)
  end

  before :each do
    @decks = []
    @decks << FactoryGirl.create(:arena_card_deck, :user_id => @user.id, :num_games_won => 3, :num_games_lost => 3, :hero_id => @shaman.id) 
    @decks << FactoryGirl.create(:arena_card_deck, :user_id => @user.id, :num_games_won => 3, :num_games_lost => 3, :hero_id => @shaman.id) 
    @decks << FactoryGirl.create(:arena_card_deck, :user_id => @user.id, :num_games_won => 4, :num_games_lost => 3, :hero_id => @warlock.id) 
    @decks << FactoryGirl.create(:arena_card_deck, :user_id => @user.id, :num_games_won => 4, :num_games_lost => 3, :hero_id => @warlock.id) 
  end

  describe '#by_hero' do
    it 'banana' do 
      expect(@decks).not_to be_nil
      num_decks = DeckStats::NumDecksStat.new(@decks)
      by_hero = num_decks.by_hero

      shaman_decks = by_hero.find {|stat| stat[:hero] == @shaman}
      expect(shaman_decks[:value]).to eq(2)

      hunter_decks = by_hero.find {|stat| stat[:hero] == @hunter}
      expect(hunter_decks[:value]).to eq(0)
    end
  end

  describe '#total' do
    it 'banana' do
      num_decks = DeckStats::NumDecksStat.new(@decks)
      expect(num_decks.total).to eq(4)
    end
  end
end

