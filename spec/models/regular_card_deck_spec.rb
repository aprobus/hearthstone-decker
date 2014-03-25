require 'spec_helper'

describe RegularCardDeck do

  before :each do
    @user = User.first || User.create!(:email => 'test@test.com', :password => '12345678')
    authenticate_as @user
  end

  describe 'Validations' do
    it 'should require a user' do
      deck = RegularCardDeck.new
      deck.hero = Hero.first

      expect(deck).to be_invalid
      expect(deck.errors[:user]).to have(1).items
      expect(deck.errors[:user][0]).to include('blank')
    end

    it 'should require a hero' do
      deck = RegularCardDeck.new
      deck.user = @user

      expect(deck).to be_invalid
      expect(deck.errors[:hero]).to have(1).items
      expect(deck.errors[:hero][0]).to include('blank')
    end

    it 'should check name length' do
      deck = RegularCardDeck.new
      deck.user = @user
      deck.hero = Hero.first
      deck.name = 'a' * 65

      expect(deck).to be_invalid
      expect(deck.errors[:name]).to have(1).items
      expect(deck.errors[:name][0]).to include('too long')
    end

    it 'should check name not blank' do
      deck = RegularCardDeck.new
      deck.user = @user
      deck.hero = Hero.first
      deck.name = ''

      expect(deck).to be_invalid
      expect(deck.errors[:name]).to have(1).items
      expect(deck.errors[:name][0]).to include('blank')
    end

    it 'should only allow 30 cards per deck' do
      deck = RegularCardDeck.new
      deck.user = @user
      deck.hero = Hero.first
      deck.name = 'Test deck'
      deck.save!

      30.times do
        card = FactoryGirl.create :card
        deck.cards << card
      end

      card = FactoryGirl.create :card
      expect { deck.cards << card }.to raise_error
      expect(deck.cards(true)).to have(30).items
    end

    it 'should allow max of 2 of each cards', :focus => true do
      deck = FactoryGirl.create :regular_card_deck

      card = FactoryGirl.create :card
      2.times{ deck.cards << card }

      expect{ deck.cards << card }.to raise_error
      expect(deck.cards(true)).to have(2).items
    end
  end
end
