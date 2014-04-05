module GameFileParser
  class Csv
    def initialize(file, user)
      @file = file
      @user = user
    end

    def parse
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

      game_import = GameImport.new
      game_import.user = @user
      game_import.file_name = File.basename(@file.path)
      yield game_import if block_given?
      game_import.save!
  
      import_arena_games game_import, results

      return game_import
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
        hero = map_hero_name(game_opt)
        if arena_card_deck.nil? || !arena_card_deck.add_games? || arena_card_deck.hero != hero
          arena_card_deck = ArenaCardDeck.new(:user => @user, :hero => hero, :game_import => game_import)
          arena_card_deck.save!
        end 

        arena_card_deck.add_game do |game|
          game.user = @user
          game.win_ind = map_win_ind(game_opt)
          game.hero = map_opponent_hero_name(game_opt)
          game.mode = 'arena'
          game.game_import = game_import
        end
      end
    end

    def map_hero_name(opts)
      Hero.find_by_name(opts[:hero_name].downcase)
    end

    def map_opponent_hero_name(opts)
      Hero.find_by_name(opts[:opponent_hero_name].downcase)
    end

    def map_win_ind(opts)
      ['true', 'y', 'yes', 'win', 'w'].include?(opts[:win_ind].downcase)
    end
  end
end

