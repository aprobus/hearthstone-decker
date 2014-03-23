class RegularCardDeck < CardDeck

  validates :name, :length => { :maximum => 64 }, :presence => true

  def before_card_added(added_card)
    if self.cards.where(:id => added_card.id).count >= 2
      raise Exception.new('Deck can only contain 2 of each card')
    end
  end

  def add_games?
    true
  end

end