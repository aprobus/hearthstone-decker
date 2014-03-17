require 'spec_helper'

describe Game do

  before :all do
    @user = User.create(:email => 'test@test.com', :password => '12345678')
    @deck = CardDeck.new(:user => @user, :name => 'Test Deck', :hero => Hero.first)
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

    it 'should allow valid game types' do
      game = Game.new
      game.user = @user
      game.card_deck = @deck
      game.hero = Hero.first

      ['ranked', 'normal', 'arena'].each do |mode|
        game.mode = mode
        expect(game).to be_valid
      end
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
  end
end
