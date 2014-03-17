class CardDeck < ActiveRecord::Base

  validates :user, :presence => true
  validates :hero, :presence => true
  validates :name, :length => { :maximum => 64 }, :presence => true

  belongs_to :hero
  belongs_to :user
  has_and_belongs_to_many :cards, :before_add => :limit_number_of_cards

  def limit_number_of_cards(added_card)
    raise Exception.new('Card limit for the deck reached') if cards.size >= 30
  end

end
