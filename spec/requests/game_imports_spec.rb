require 'spec_helper'

describe "GameImports" do
  describe "GET /game_imports" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get game_imports_path
      response.status.should be(200)
    end
  end
end
