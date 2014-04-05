class GameImport < ActiveRecord::Base
  validates :user, :presence => true
  validates :file_name, :presence => true, :length => { :maximum => 64 }

  belongs_to :user
  has_many :games
  has_many :card_decks

  def num_games_imported
    self.games.count
  end
end

