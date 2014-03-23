require 'spec_helper'

describe ArenaCardDeck do

  before :each do
    @user = User.first || User.create!(:email => 'test@test.com', :password => '12345678')
  end

  describe 'validations' do
    it 'should not allow more than 3 losses' do
      deck = ArenaCardDeck.new
      deck.num_games_lost = 4
      expect(deck).to be_invalid
      expect(deck.errors[:num_games_lost]).to have(1).items
      expect(deck.errors[:num_games_lost][0]).to include('less than')
    end

    it 'should not allow more than 12 wins' do
      deck = ArenaCardDeck.new
      deck.num_games_won = 13
      expect(deck).to be_invalid
      expect(deck.errors[:num_games_won]).to have(1).items
      expect(deck.errors[:num_games_won][0]).to include('less than')
    end
  end

  describe '#add_games?' do
    it 'should not allow games after 3 losses' do
      deck = ArenaCardDeck.new
      deck.num_games_lost = 3
      deck.num_games_won = 0
      expect(deck.add_games?).to be_false
    end

    it 'should not allow games after 12 wins' do
      deck = ArenaCardDeck.new
      deck.num_games_lost = 2
      deck.num_games_won = 12
      expect(deck.add_games?).to be_false
    end

    it 'should allow adding for valid numbers' do
      deck = ArenaCardDeck.new
      deck.num_games_lost = 2
      deck.num_games_won = 11
      expect(deck.add_games?).to be_true
    end
  end

end
