require 'spec_helper'

describe "arena_card_decks/index" do
  before(:each) do
    assign(:arena_card_decks, [
      stub_model(ArenaCardDeck),
      stub_model(ArenaCardDeck)
    ])
  end

  it "renders a list of arena_card_decks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
