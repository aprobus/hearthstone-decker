require 'spec_helper'

describe "arena_card_decks/new" do
  before(:each) do
    assign(:arena_card_deck, stub_model(ArenaCardDeck).as_new_record)
  end

  it "renders new arena_card_deck form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", arena_card_decks_path, "post" do
    end
  end
end
