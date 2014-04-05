require 'spec_helper'

describe "game_imports/show" do
  before(:each) do
    @game_import = assign(:game_import, stub_model(GameImport,
      :card_deck_id => 1,
      :import_type => "Import Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Import Type/)
  end
end
