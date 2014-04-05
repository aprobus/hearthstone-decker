require "spec_helper"

describe GameImportsController do
  describe "routing" do

    it "routes to #index" do
      get("/game_imports").should route_to("game_imports#index")
    end

    it "routes to #new" do
      get("/game_imports/new").should route_to("game_imports#new")
    end

    it "routes to #show" do
      get("/game_imports/1").should route_to("game_imports#show", :id => "1")
    end

    it "routes to #edit" do
      get("/game_imports/1/edit").should route_to("game_imports#edit", :id => "1")
    end

    it "routes to #create" do
      post("/game_imports").should route_to("game_imports#create")
    end

    it "routes to #update" do
      put("/game_imports/1").should route_to("game_imports#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/game_imports/1").should route_to("game_imports#destroy", :id => "1")
    end

  end
end
