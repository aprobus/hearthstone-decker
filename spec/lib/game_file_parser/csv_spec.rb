require 'spec_helper'
require 'game_file_parser/csv'

describe GameFileParser::Csv do
  describe '#can_parse?' do
    it 'can parse csv files' do
      expect(GameFileParser::Csv.can_parse?('text/csv')).to be_true
    end

    it 'can parse text files' do
      expect(GameFileParser::Csv.can_parse?('text/plain')).to be_true
    end

    it 'cannot parse other files' do
      expect(GameFileParser::Csv.can_parse?('text/json')).to be_false
    end
  end

  describe '#parse' do
    before :each do
      @user = User.first || User.create!(:email => 'test1@abc.com', :password => '12345678')
      authenticate_as @user
    end

    it 'should return 1 game per line' do
      file = generate_csv_file do |csv|
        csv << ['Apr-3', 'Shaman', 'Warlock', 'Arena', 'Win']
      end

      parser = GameFileParser::Csv.new(file, @user)
      result = parser.parse

      expect(result).not_to be_nil
      expect(result.games).to have(1).items
      expect(result.card_decks).to have(1).items

      created_deck = result.card_decks[0]
      expect(created_deck).to be_a(ArenaCardDeck)
      expect(created_deck.hero.name).to eq('shaman')
      expect(created_deck.num_games_won).to eq(1)
      expect(created_deck.num_games_lost).to eq(0)

      created_game = result.games[0]
      expect(created_game.hero.name).to eq('warlock')
      expect(created_game.win_ind).to be_true
    end

    it 'should create multiple decks for arena' do
      file = generate_csv_file do |csv|
        csv << ['Apr-3', 'Shaman', 'Warlock', 'Arena', 'Loss']
        csv << ['Apr-3', 'Shaman', 'Warlock', 'Arena', 'N']
        csv << ['Apr-3', 'Shaman', 'Warlock', 'Arena', 'No']
        csv << ['Apr-3', 'Shaman', 'Warlock', 'Arena', 'Lose']
      end

      parser = GameFileParser::Csv.new(file, @user)
      result = parser.parse

      expect(result).not_to be_nil
      expect(result.games).to have(4).items
      expect(result.card_decks).to have(2).items

      result.games.each do |game|
        expect(game.win_ind).to be_false
      end
    end

    def generate_csv_file
      csv_str = CSV.generate do |csv|
        csv << ['Date', 'Class', 'Opponent', 'Game Type', 'Result']
        yield csv
      end
      file = Tempfile.new('test')
      file.write csv_str
      file.close
      file
    end
  end
end

