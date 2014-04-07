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
      result, errors = parser.process

      expect(errors).to be_empty
      expect(result).not_to be_nil
      expect(result.games).to have(1).items
      expect(result.card_decks).to have(1).items

      created_deck = result.card_decks[0]
      expect(created_deck).to be_a(ArenaCardDeck)
      expect(created_deck.hero.name).to eq('shaman')
      expect(created_deck.num_games_won).to eq(1)
      expect(created_deck.num_games_lost).to eq(0)
      expect(created_deck.created_at).to eq(Date.new(2014, 04, 03))

      created_game = result.games[0]
      expect(created_game.hero.name).to eq('warlock')
      expect(created_game.win_ind).to be_true
      expect(created_game.created_at).to eq(Date.new(2014, 04, 03))
    end

    it 'should ignore illegal dates' do
      file = generate_csv_file do |csv|
        csv << ['Apr-33', 'Shaman', 'Warlock', 'Arena', 'Win']
      end

      parser = GameFileParser::Csv.new(file, @user)
      result, errors = parser.process

      expect(errors).to be_empty
      expect(result).not_to be_nil
      expect(result.games).to have(1).items
      expect(result.card_decks).to have(1).items

      created_deck = result.card_decks[0]
      expect(created_deck.created_at).to be_within(2.seconds).of(Time.now)

      created_game = result.games[0]
      expect(created_game.created_at).to be_within(2.seconds).of(Time.now)
    end

    it 'should work correctly with no date field' do
      file = generate_csv_file(['Class', 'Opponent', 'Game Type', 'Result']) do |csv|
        csv << ['Shaman', 'Warlock', 'Arena', 'Win']
      end

      parser = GameFileParser::Csv.new(file, @user)
      result, errors = parser.process

      expect(errors).to be_empty
      expect(result).not_to be_nil
      expect(result.games).to have(1).items
      expect(result.card_decks).to have(1).items

      created_deck = result.card_decks[0]
      expect(created_deck.created_at).to be_within(2.seconds).of(Time.now)

      created_game = result.games[0]
      expect(created_game.created_at).to be_within(2.seconds).of(Time.now)
    end

    it 'should create multiple decks for arena' do
      file = generate_csv_file do |csv|
        csv << ['Apr-3', 'Shaman', 'Warlock', 'Arena', 'Loss']
        csv << ['Apr-3', 'Shaman', 'Warlock', 'Arena', 'N']
        csv << ['Apr-3', 'Shaman', 'Warlock', 'Arena', 'No']
        csv << ['Apr-3', 'Shaman', 'Warlock', 'Arena', 'Lose']
      end

      parser = GameFileParser::Csv.new(file, @user)
      result, errors = parser.process

      expect(errors).to be_empty
      expect(result).not_to be_nil
      expect(result.games).to have(4).items
      expect(result.card_decks).to have(2).items

      result.games.each do |game|
        expect(game.win_ind).to be_false
      end
    end

    it 'should handling missing games' do
      file = generate_csv_file do |csv|
        csv << ['Apr-3', 'Shaman', 'Warlock', 'Arena', 'Loss']
        csv << ['Apr-3', 'Shaman', 'Warlock', 'Arena', 'N']
        csv << ['Apr-3', 'Priest', 'Warlock', 'Arena', 'No']
      end

      parser = GameFileParser::Csv.new(file, @user)
      result, errors = parser.process

      expect(errors).to be_empty
      expect(result).not_to be_nil
      expect(result.games).to have(3).items
      expect(result.card_decks).to have(2).items

      decks = result.card_decks.order(:id => :asc)
      expect(decks[0].hero.name).to eq('shaman')
      expect(decks[0].games.count).to eq(2)

      expect(decks[1].hero.name).to eq('priest')
      expect(decks[1].games.count).to eq(1)
    end

    it 'should not fail for 2 invalid lines in a row' do
      num_card_decks = CardDeck.count
      num_games = Game.count
      file = generate_csv_file do |csv|
        csv << ['Apr-3', 'Shaman', 'Warlock', 'Arena', 'Loss']
        csv << ['Apr-3', '2', 'Warlock', 'Arena', 'N']
        csv << ['Apr-3', '2', 'Warlock', 'Arena', 'No']
      end

      parser = nil
      expect{ parser = GameFileParser::Csv.new(file, @user) }.not_to change{GameImport.count}
      result, errors = parser.process

      expect(errors).to have(2).items
      expect(result).to be_nil
      expect(CardDeck.count).to eq(num_card_decks)
      expect(Game.count).to eq(num_games)
    end

    def generate_csv_file(headers = ['Date', 'Class', 'Opponent', 'Game Type', 'Result'])
      csv_str = CSV.generate do |csv|
        csv << headers
        yield csv
      end
      file = Tempfile.new('test')
      file.write csv_str
      file.close
      file
    end
  end
end

