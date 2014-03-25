require 'spec_helper'

describe Game do
  include Grant::Status

  before :all do
    @user = User.first || User.create!(:email => 'test@test.com', :password => '12345678')
    @other_user = User.second || User.create!(:email => 'test2@test.com', :password => '12345678')

    without_grant do
      @deck = FactoryGirl.create(:regular_card_deck)
    end
  end

  describe 'Validations' do
    before :each do
      authenticate_as @user
    end

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

    it 'should check if deck can add games' do
      authenticate_as @user
      deck = FactoryGirl.create :arena_card_deck
      deck.num_games_lost = 3
      deck.save!

      game = Game.new
      game.user = @user
      game.hero = Hero.first
      game.card_deck = deck

      expect(game).to be_invalid
      expect(game.errors[:base]).to have(1).items
      expect(game.errors[:base][0]).to include('Cannot add games')
    end
  end
end
