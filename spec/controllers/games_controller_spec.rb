require 'spec_helper'

describe GamesController do

  before :all do
    @users = [
        User.first || User.create!(:email => 'test1@test.com', :password => '12345678'),
        User.second || User.create!(:email => 'test2@test.com', :password => '12345678')
    ]

    @decks = [
        FactoryGirl.create(:arena_card_deck, :user_id => @users[0].id),
        FactoryGirl.create(:arena_card_deck, :user_id => @users[1].id)
    ]

    @warlock = Hero.find_by_name 'warlock'
  end

  describe 'POST create' do
    before :each do
      sign_in @users[0]
    end

    it 'should should create a game' do
      expect {
        post :create, :arena_card_deck_id => @decks[0].id, :game => { :win_ind => 0, :hero_id => @warlock.to_param, :mode => 'arena' }
      }.to change{ Game.count }.by(1)

      expect(response).to redirect_to(@decks[0])
    end

    it 'should increment number of losses' do
      post :create, :arena_card_deck_id => @decks[0].id, :game => { :win_ind => 0, :hero_id => @warlock.to_param, :mode => 'arena' }

      @decks[0].reload
      expect(@decks[0].num_games_lost).to eq(1)
    end

    it 'should increment number of wins' do
      post :create, :arena_card_deck_id => @decks[0].id, :game => { :win_ind => 1, :hero_id => @warlock.to_param, :mode => 'arena' }

      @decks[0].reload
      expect(@decks[0].num_games_won).to eq(1)
    end

    it 'should not change anything when adding game fails' do
      @decks[0].num_games_won = 0
      @decks[0].num_games_lost = 3
      @decks[0].save!

      expect {
        post :create, :arena_card_deck_id => @decks[0].id, :game => { :win_ind => 1, :hero_id => @warlock.to_param, :mode => 'arena' }
      }.not_to change{ Game.count }

      @decks[0].reload
      expect(@decks[0].num_games_lost).to eq(3)
      expect(@decks[0].num_games_won).to eq(0)
    end
  end

end
