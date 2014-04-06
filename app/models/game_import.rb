class GameImport < ActiveRecord::Base
  validates :user, :presence => true
  validates :file_name, :presence => true, :length => { :maximum => 64 }

  belongs_to :user
  has_many :games, :dependent => :destroy
  has_many :card_decks, :dependent => :destroy

  grant(:create, :find, :update, :destroy) { |user, model, action| !user.nil? && model.user_id == user.id }

  def num_games_imported
    self.games.count
  end
end

