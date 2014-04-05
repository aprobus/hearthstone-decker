require 'spec_helper'

describe "game_imports/index" do
  before(:each) do
    assign(:game_imports, [
      stub_model(GameImport,
        :card_deck_id => 1,
        :import_type => "Import Type"
      ),
      stub_model(GameImport,
        :card_deck_id => 1,
        :import_type => "Import Type"
      )
    ])
  end

  it "renders a list of game_imports" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Import Type".to_s, :count => 2
  end
end
