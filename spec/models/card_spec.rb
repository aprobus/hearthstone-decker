require 'spec_helper'

describe Card do
  describe 'Validations' do
    it 'should not allow blank name' do
      card = Card.new(:name => '', :card_text => 'Text', :card_type => 'minion', :mana => 2, :health => 2)

      expect(card).to be_invalid
      expect(card.errors[:name]).to have(1).items
      expect(card.errors[:name][0]).to include('blank')
    end

    it 'should not allow blank card type' do
      card = Card.new(:name => 'Ancient of Lore', :card_text => 'Text', :card_type => '', :mana => 2, :health => 2)

      expect(card).to be_invalid
      expect(card.errors[:card_type]).to have(1).items
      expect(card.errors[:card_type][0]).to include('not included')
    end

    it 'should allow valid card types' do
      ['minion', 'spell', 'weapon'].each do |card_type|
        card = Card.new(:name => 'Ancient of Lore', :card_text => 'Text', :card_type => card_type, :mana => 2, :health => 2, :rarity => 'common')
        expect(card).to be_valid
      end
    end

    it 'should not allow other card types' do
      card = Card.new(:name => 'Ancient of Lore', :card_text => 'Text', :card_type => 'banana', :mana => 2, :health => 2)

      expect(card).to be_invalid
      expect(card.errors[:card_type]).to have(1).items
      expect(card.errors[:card_type][0]).to include('not included')
    end

    it 'should not allow blank mana cost' do
      card = Card.new(:name => 'Ancient of Lore', :card_text => 'Text', :card_type => 'minion', :mana => nil, :health => 2)

      expect(card).to be_invalid
      expect(card.errors[:mana]).to have(1).items
      expect(card.errors[:mana][0]).to include('not a number')
    end

    it 'should not allow negative mana cost' do
      card = Card.new(:name => 'Ancient of Lore', :card_text => 'Text', :card_type => 'minion', :mana => -1, :health => 2)

      expect(card).to be_invalid
      expect(card.errors[:mana]).to have(1).items
      expect(card.errors[:mana][0]).to include('must be greater')
    end

    it 'should allow all valid card rarities' do
      card = Card.new(:name => 'Ancient of Lore', :card_text => 'Text', :card_type => 'minion', :mana => 0, :health => 2)
      ['soul_bound', 'common', 'rare', 'epic', 'legendary'].each do |rarity|
        card.rarity = rarity
        expect(card).to be_valid
      end
    end

    it 'should not allow negative damange' do
      card = Card.new(:damage => -1)

      expect(card).to be_invalid
      expect(card.errors[:damage]).to have(1).items
      expect(card.errors[:damage][0]).to include('must be greater')
    end
  end

  describe 'Relations' do
    it 'should have a hero' do
      hero = Hero.create(:name => 'warlock')
      card = Card.new(:name => 'Ancient of Lore', :card_text => 'Text', :card_type => 'minion', :mana => 2, :health => 2, :rarity => 'common')

      card.hero = hero
      card.save!
    end
  end
end
