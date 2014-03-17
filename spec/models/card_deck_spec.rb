require 'spec_helper'

describe CardDeck do

  before :each do
    @user = User.first || User.create!(:email => 'test@test.com', :password => '12345678')
  end

  describe 'Validations' do
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

    it 'should check name length' do
      deck = CardDeck.new
      deck.user = @user
      deck.hero = Hero.first
      deck.name = 'a' * 65

      expect(deck).to be_invalid
      expect(deck.errors[:name]).to have(1).items
      expect(deck.errors[:name][0]).to include('too long')
    end

    it 'should check name not blank' do
      deck = CardDeck.new
      deck.user = @user
      deck.hero = Hero.first
      deck.name = ''

      expect(deck).to be_invalid
      expect(deck.errors[:name]).to have(1).items
      expect(deck.errors[:name][0]).to include('blank')
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
  end
end
