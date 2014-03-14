require 'spec_helper'

describe Hero do
  describe 'Validations' do
    it 'should require name' do
      hero = Hero.new
      hero.name = nil

      expect(hero).not_to be_valid
      expect(hero.errors[:name]).to have(1).items
      expect(hero.errors[:name][0]).to include('blank')
    end

    it 'should check name uniqueness' do
      Hero.create(:name => 'warlock')

      hero = Hero.new(:name => 'warlock')
      expect(hero).not_to be_valid
      expect(hero.errors[:name]).to have(1).items
      expect(hero.errors[:name][0]).to include('taken')
    end
  end
end
