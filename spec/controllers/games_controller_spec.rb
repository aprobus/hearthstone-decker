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

  describe 'POST create'
  it 'should should create a game' do
    sign_in @users[0]

    expect {
      post :create, :arena_card_deck_id => @decks[0].id, :game => { :win_ind => 0, :hero_id => @warlock.to_param, :mode => 'arena' }
    }.to change{ Game.count }.by(1)

    expect(response).to redirect_to(@decks[0])
  end
end
