require 'spec_helper'

describe "arena_card_decks/show" do
  before(:each) do
    @arena_card_deck = assign(:arena_card_deck, stub_model(ArenaCardDeck))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
