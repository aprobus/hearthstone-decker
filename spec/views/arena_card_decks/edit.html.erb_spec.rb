require 'spec_helper'

describe "arena_card_decks/edit" do
  before(:each) do
    @arena_card_deck = assign(:arena_card_deck, stub_model(ArenaCardDeck))
  end

  it "renders the edit arena_card_deck form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", arena_card_deck_path(@arena_card_deck), "post" do
    end
  end
end
