require 'spec_helper'

describe GameImport do
  describe 'Validations' do
    it 'should require a user' do
      game_imp = GameImport.new(:file_name => 'banana')

      expect(game_imp).to be_invalid
      expect(game_imp.errors[:user]).to have(1).items
      expect(game_imp.errors[:user][0]).to include('blank')
    end

    it 'should require a file name' do
      game_imp = GameImport.new(:file_name => '')

      expect(game_imp).to be_invalid
      expect(game_imp.errors[:file_name]).to have(1).items
      expect(game_imp.errors[:file_name][0]).to include('blank')
    end

    it 'should check file name length' do
      game_imp = GameImport.new(:file_name => 'b' * 65)

      expect(game_imp).to be_invalid
      expect(game_imp.errors[:file_name]).to have(1).items
      expect(game_imp.errors[:file_name][0]).to include('64')
    end
  end

  describe 'Associations' do
    before :each do
      @user = User.first
      authenticate_as @user
    end

    it 'should delete associated games and decks' do
      game_import = GameImport.create!(:file_name => 'test.csv', :user => @user)
      card_deck = ArenaCardDeck.create!(:hero => Hero.first, :user => @user, :game_import => game_import) 
      game = Game.create!(:hero => Hero.first, :mode => 'arena', :win_ind => true, :game_import => game_import, :user => @user, :card_deck => card_deck)

      game_import.destroy
      expect(CardDeck.exists?(card_deck)).to be_false
      expect(Game.exists?(game)).to be_false
    end
  end
end

