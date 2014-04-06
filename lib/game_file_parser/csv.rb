module GameFileParser
  class Csv
    def initialize(file, user)
      @file = file
      @user = user
    end

    def process
      if @file.nil?
        return nil, ['No file given']
      end

      # Key Mappings
      # :hero_name = [:hero_name, :class]
      # :opponent_hero_name = [:opponent_hero_name, :opponent]
      # :win_ind = [:win_ind, :result]
      # :mode = [:mode, :game_type]
      # :date = [:date]
      key_maps = {}
      key_maps[:class] = :hero_name
      key_maps[:opponent] = :opponent_hero_name
      key_maps[:result] = :win_ind
      key_maps[:game_type] = :mode

      results = SmarterCSV.process(@file.path, :key_mapping => key_maps)
      results.each_with_index do |result, i|
        result[:line_num] = i + 2 # Header + 1 based index
      end

      @errors = []

      game_import = nil
      GameImport.transaction do
        game_import = GameImport.new
        game_import.user = @user
        game_import.file_name = File.basename(@file.path)
        yield game_import if block_given?
        game_import.save!
    
        import_arena_games game_import, results

        if !@errors.empty?
          raise ActiveRecord::Rollback
        end
      end

      if @errors.empty?
        return game_import, []
      else
        return nil, @errors
      end
    end

    def self.can_parse?(content_type)
      return ['text/csv', 'text/plain'].include?(content_type)
    end

    private

    def import_arena_games(game_import, game_opts)
      arena_games = game_opts.select do |game_opt|
        game_opt[:mode].downcase == 'arena'
      end

      arena_card_deck = nil
      arena_games.each do |game_opt|
        arena_card_deck = build_arena_game(game_opt, game_import, arena_card_deck)
      end
    end

    def build_arena_game(game_opt, game_import, arena_card_deck)
      hero = map_hero_name(game_opt)
      played_at = map_date(game_opt)
      deck_for_game = arena_card_deck
      if arena_card_deck.nil? || !arena_card_deck.add_games? || arena_card_deck.hero != hero
        deck_for_game = ArenaCardDeck.new(:user => @user, :hero => hero, :game_import => game_import, :created_at => played_at)
        if !deck_for_game.save
          @errors << "Line #{game_opt[:line_num]} is invalid"
          return nil
        end
      end 

      added_game = deck_for_game.add_game do |game|
        game.user = @user
        game.win_ind = map_win_ind(game_opt)
        game.hero = map_opponent_hero_name(game_opt)
        game.mode = 'arena'
        game.game_import = game_import
        game.created_at = played_at
      end

      if !added_game.persisted?
        @errors << "Line #{game_opt[:line_num]} is invalid"
      end

      return deck_for_game
    end

    def map_hero_name(opts)
      find_hero_for_sym opts, :hero_name
    end

    def map_opponent_hero_name(opts)
      find_hero_for_sym opts, :opponent_hero_name
    end

    def find_hero_for_sym(opts, sym)
      if opts.include?(sym) && opts[sym].is_a?(String)
        Hero.find_by_name(opts[sym].downcase)
      else
        nil
      end
    end

    def map_win_ind(opts)
      ['true', 'y', 'yes', 'win', 'w'].include?(opts[:win_ind].downcase)
    end

    def map_date(opts)
      if !opts.include?(:date) || !opts[:date].is_a?(String)
        return nil
      end

      begin
        Date.parse(opts[:date])
      rescue ArgumentError
        nil
      end
    end
  end
end

