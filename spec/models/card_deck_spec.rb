require 'spec_helper'
require 'grant/error'

describe CardDeck do

  before :each do
    @user = User.first || User.create!(:email => 'test@test.com', :password => '12345678')
    @other_user = User.second || User.create!(:email => 'test2@test.com', :password => '12345678')
  end

  describe 'Validations' do
    before :each do
      authenticate_as @user
    end

    it 'should require a user' do
      deck = CardDeck.new
      deck.hero = Hero.first

      expect(deck).to be_invalid
      expect(deck.errors[:user]).to have(1).items
      expect(deck.errors[:user][0]).to include('blank')
    end

    it 'should require a hero' do
      deck = CardDeck.new
      deck.user = @user

      expect(deck).to be_invalid
      expect(deck.errors[:hero]).to have(1).items
      expect(deck.errors[:hero][0]).to include('blank')
    end

    it 'should only allow 30 cards per deck' do
      deck = CardDeck.new
      deck.user = @user
      deck.hero = Hero.first
      deck.name = 'Test deck'
      deck.save!

      30.times do
        card = FactoryGirl.create :card
        deck.cards << card
      end

      card = Card.create(:name => 'Too Many Cards')
      expect { deck.cards << card }.to raise_error
      expect(deck.cards(true)).to have(30).items
    end

    it 'should not allow negative num of games lost' do
      deck = CardDeck.new
      deck.user = @user
      deck.hero = Hero.first
      deck.name = 'Test deck'
      deck.num_games_won = 0
      deck.num_games_lost = -1

      expect(deck).to be_invalid
      expect(deck.errors[:num_games_lost]).to have(1).items
      expect(deck.errors[:num_games_lost][0]).to include('greater than')
    end

    it 'should not allow negative num of games won' do
      deck = CardDeck.new
      deck.user = @user
      deck.hero = Hero.first
      deck.name = 'Test deck'
      deck.num_games_won = -1
      deck.num_games_lost = 0

      expect(deck).to be_invalid
      expect(deck.errors[:num_games_won]).to have(1).items
      expect(deck.errors[:num_games_won][0]).to include('greater than')
    end

    it 'should not allow a user to create a deck for another user' do
      deck = CardDeck.new
      deck.user = @other_user
      deck.hero = Hero.first
      deck.name = 'Test deck'

      expect {
        deck.save
      }.to raise_error{|error| expect(error).to be_a(Grant::Error)}
    end
  end

  describe '#num_games_total' do
    it 'should equal the sum of wins and losses' do
      deck = CardDeck.new
      deck.num_games_won = 3
      deck.num_games_lost = 4

      expect(deck.num_games_total).to eq(7)
    end
  end

  describe 'Permissions' do
    before :each do
      authenticate_as @user
    end

    it 'should not allow other users to view' do
      deck = FactoryGirl.create(:arena_card_deck, :user_id => @user.id)

      expect(deck.granted?(:find, @other_user)).to be_false
      authenticate_as @other_user
      expect {
        CardDeck.find(deck.id)
      }.to raise_exception{|error| expect(error).to be_a(Grant::Error)}
    end

    it 'should not allow other users to update' do
      deck = FactoryGirl.create(:arena_card_deck, :user_id => @user.id)

      expect(deck.granted?(:update, @other_user)).to be_false
    end

    it 'should not allow other users to delete' do
      deck = FactoryGirl.create(:arena_card_deck, :user_id => @user.id)

      expect(deck.granted?(:destroy, @other_user)).to be_false
    end
  end
end
