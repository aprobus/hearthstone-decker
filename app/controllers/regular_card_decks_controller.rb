class RegularCardDecksController < CardDecksBaseController

  def controller_model
    RegularCardDeck
  end

  def editable_fields
    [:name]
  end

end

