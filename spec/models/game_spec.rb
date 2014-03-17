require 'spec_helper'

describe Game do

  before :all do
    @user = User.create(:email => 'test@test.com', :password => '12345678')
    @deck = FactoryGirl.create(:regular_card_deck)
  end

  describe 'Validations' do
    it 'should require a user' do
      game = Game.new
      game.card_deck = @deck
      game.hero = Hero.first
      game.mode = 'ranked'

      expect(game).to be_invalid
      expect(game.errors[:user]).to have(1).items
      expect(game.errors[:user][0]).to include('blank')
    end

    it 'should require a hero' do
      game = Game.new
      game.user = @user
      game.card_deck = @deck
      game.mode = 'ranked'

      expect(game).to be_invalid
      expect(game.errors[:hero]).to have(1).items
      expect(game.errors[:hero][0]).to include('blank')
    end

    it 'should require a deck' do
      game = Game.new
      game.user = @user
      game.hero = Hero.first
      game.mode = 'ranked'

      expect(game).to be_invalid
      expect(game.errors[:card_deck]).to have(1).items
      expect(game.errors[:card_deck][0]).to include('blank')
    end

    it 'should not allow invalid game types' do
      game = Game.new
      game.user = @user
      game.hero = Hero.first
      game.mode = 'test'

      expect(game).to be_invalid
      expect(game.errors[:mode]).to have(1).items
      expect(game.errors[:mode][0]).to include('not a valid game mode')
    end

    it 'should only allow regular decks for normal/ranked' do
      arena_deck = FactoryGirl.create :arena_card_deck
      expect(arena_deck.class == ArenaCardDeck).to be_true

      game = Game.new
      game.user = @user
      game.hero = Hero.first
      game.card_deck = arena_deck

      ['normal', 'ranked'].each do |mode|
        game.mode = mode
        expect(game).to be_invalid
        expect(game.errors[:card_deck]).to have(1).items
        expect(game.errors[:card_deck][0]).to include('not a valid deck for game mode')
      end
    end

    it 'should only allow arena decks for arena games' do
      deck = FactoryGirl.create :regular_card_deck
      expect(deck.class == RegularCardDeck).to be_true

      game = Game.new
      game.user = @user
      game.hero = Hero.first
      game.card_deck = deck

      ['arena'].each do |mode|
        game.mode = mode
        expect(game).to be_invalid
        expect(game.errors[:card_deck]).to have(1).items
        expect(game.errors[:card_deck][0]).to include('not a valid deck for game mode')
      end
    end
  end
end
