require 'spec_helper'

describe "game_imports/new" do
  before(:each) do
    assign(:game_import, stub_model(GameImport,
      :card_deck_id => 1,
      :import_type => "MyString"
    ).as_new_record)
  end

  it "renders new game_import form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", game_imports_path, "post" do
      assert_select "input#game_import_card_deck_id[name=?]", "game_import[card_deck_id]"
      assert_select "input#game_import_import_type[name=?]", "game_import[import_type]"
    end
  end
end
