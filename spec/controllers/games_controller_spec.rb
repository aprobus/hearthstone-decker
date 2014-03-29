require 'spec_helper'

describe GamesController do
  include Grant::Status

  before :all do
    @users = [
        User.first || User.create!(:email => 'test1@test.com', :password => '12345678'),
        User.second || User.create!(:email => 'test2@test.com', :password => '12345678')
    ]

    without_grant do
      @decks = [
          FactoryGirl.create(:arena_card_deck, :user_id => @users[0].id),
          FactoryGirl.create(:arena_card_deck, :user_id => @users[1].id)
      ]
    end

    @warlock = Hero.find_by_name 'warlock'
  end

  describe 'POST create' do
    before :each do
      authenticate_as @users[0]
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
      without_grant do
        @decks[0].num_games_won = 0
        @decks[0].num_games_lost = 3
        @decks[0].save!
      end

      expect {
        post :create, :arena_card_deck_id => @decks[0].id, :game => { :win_ind => 1, :hero_id => @warlock.to_param, :mode => 'arena' }
      }.not_to change{ Game.count }

      @decks[0].reload
      expect(@decks[0].num_games_lost).to eq(3)
      expect(@decks[0].num_games_won).to eq(0)
    end

    it 'should fail when user is not authorized' do
      authenticate_as @users[1]

      expect do
        post :create, :arena_card_deck_id => @decks[0].id, :game => { :win_ind => 1, :hero_id => @warlock.to_param, :mode => 'arena' }
      end.to raise_error{|error| expect(error).to be_a(Grant::Error)}

      authenticate_as @users[0]
      @decks[0].reload
      expect(@decks[0].num_games_won).to eq(0)
      expect(@decks[0].num_games_lost).to eq(0)
    end
  end

  describe 'DELETE destroy' do
    before :each do
      authenticate_as @users[0]

      @arena_card_deck = FactoryGirl.create(:arena_card_deck, :user_id => @users[0].id)
      @game = @arena_card_deck.add_game do |game|
        game.win_ind = true
        game.mode = 'arena'
        game.hero_id = Hero.first.id
        game.user = @users[0]
      end
      expect(@game).to be_persisted
    end

    it 'destroys the requested arena_card_deck' do
      expect {
        delete :destroy, {:id => @game.to_param}
      }.to change(Game, :count).by(-1)
    end

    it 'redirects to the arena_card_decks list' do
      delete :destroy, {:id => @game.to_param}
      expect(response).to redirect_to(@arena_card_deck)
    end

    it 'updates num wins' do
      delete :destroy, {:id => @game.to_param}

      @arena_card_deck.reload
      expect(@arena_card_deck.num_games_won).to eq(0)
    end

    it 'updates num losses' do
      @game.win_ind = false
      @game.save!

      @arena_card_deck.num_games_won = 0
      @arena_card_deck.num_games_lost = 1
      @arena_card_deck.save!

      delete :destroy, {:id => @game.to_param}

      @arena_card_deck.reload
      expect(@arena_card_deck.num_games_lost).to eq(0)
    end

    it 'should not allow other users to delete' do
      authenticate_as @users[1]
      expect {
        delete :destroy, {:id => @game.to_param}
      }.to raise_error{|error| expect(error).to be_a(Grant::Error)}

      expect(Game.exists?(@game)).to be_true
    end
  end

end

