require "spec_helper"

describe ArenaCardDecksController do
  describe "routing" do

    it "routes to #index" do
      get("/arena_card_decks").should route_to("arena_card_decks#index")
    end

    it "routes to #new" do
      get("/arena_card_decks/new").should route_to("arena_card_decks#new")
    end

    it "routes to #show" do
      get("/arena_card_decks/1").should route_to("arena_card_decks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/arena_card_decks/1/edit").should route_to("arena_card_decks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/arena_card_decks").should route_to("arena_card_decks#create")
    end

    it "routes to #update" do
      put("/arena_card_decks/1").should route_to("arena_card_decks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/arena_card_decks/1").should route_to("arena_card_decks#destroy", :id => "1")
    end

  end
end
