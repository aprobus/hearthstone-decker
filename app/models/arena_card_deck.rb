class ArenaCardDeck < CardDeck

  MAX_LOSSES = 3
  MAX_WINS = 12

  validates :num_games_lost, :numericality => { :only_integer => true, :less_than_or_equal_to => MAX_LOSSES }
  validates :num_games_won, :numericality => { :only_integer => true, :less_than_or_equal_to => MAX_WINS }

  def add_games?
    num_games_lost < MAX_LOSSES && num_games_won < MAX_WINS
  end

  scope :completed, -> { where("num_games_lost = #{MAX_LOSSES} or num_games_won = #{MAX_WINS}") }

end

