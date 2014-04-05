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
      game_imp = GameImport.new(:file_name => 'banana')

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
end

