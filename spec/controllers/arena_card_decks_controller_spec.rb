require 'spec_helper'

describe ArenaCardDecksController do
  include Grant::Status

  # This should return the minimal set of attributes required to create a valid
  # ArenaCardDeck. As you add validations to ArenaCardDeck, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { :hero_id => Hero.first.id } }

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
  end

  describe 'GET index' do
    it 'assigns all arena_card_decks as @arena_card_decks' do
      authenticate_as @users[0]
      get :index, {}
      expect(response).to be_ok
      assigns(:arena_card_decks).each do |deck|
        expect(deck.user_id).to eq(@users[0].id)
      end
    end

    it 'should error when no user is signed in' do
      sign_out @users[0]

      get :index, {}
      expect(response).to redirect_to '/users/sign_in'
    end
  end

  describe 'GET show' do

    it 'assigns the requested arena_card_deck as @arena_card_deck' do
      authenticate_as @users[0]
      get :show, {:id => @decks[0].id.to_param}
      expect(assigns(:arena_card_deck)).to eq(@decks[0])
    end

    it 'should not show decks that do not belong to user' do
      authenticate_as @users[1]
      Grant::User.current_user = @users[1]
      expect {
        get :show, { :id => @decks[0].id.to_param }
      }.to raise_exception{|error| expect(error).to be_a(Grant::Error)}
    end

    it 'should return 404 for unknown decks' do
      authenticate_as @users[1]
      expect {
        get :show, {:id => 12345678}
      }.to raise_exception ActiveRecord::RecordNotFound
    end
  end

  describe 'GET new' do
    it 'assigns a new arena_card_deck as @arena_card_deck' do
      authenticate_as @users[0]
      get :new
      expect(assigns(:arena_card_deck)).to be_a_new(ArenaCardDeck)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested arena_card_deck as @arena_card_deck' do
      authenticate_as @users[0]
      arena_card_deck = FactoryGirl.create(:arena_card_deck, :user_id => @users[0].id)
      get :edit, {:id => arena_card_deck.to_param}
      expect(assigns(:arena_card_deck)).to eq(arena_card_deck)
    end
  end

  describe 'POST create' do
    before :each do
      authenticate_as @users[0]
    end

    describe 'with valid params' do
      it 'creates a new ArenaCardDeck' do
        expect {
          post :create, {:arena_card_deck => valid_attributes}
        }.to change(ArenaCardDeck, :count).by(1)
      end

      it 'assigns a newly created arena_card_deck as @arena_card_deck' do
        post :create, {:arena_card_deck => valid_attributes}
        assigns(:arena_card_deck).should be_a(ArenaCardDeck)
        assigns(:arena_card_deck).should be_persisted
      end

      it 'redirects to the created arena_card_deck' do
        post :create, {:arena_card_deck => valid_attributes}
        response.should redirect_to(ArenaCardDeck.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved arena_card_deck as @arena_card_deck' do
        # Trigger the behavior that occurs when invalid params are submitted
        ArenaCardDeck.any_instance.stub(:save).and_return(false)
        post :create, {:arena_card_deck => { :banana => 3 }}
        assigns(:arena_card_deck).should be_a_new(ArenaCardDeck)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ArenaCardDeck.any_instance.stub(:save).and_return(false)
        post :create, {:arena_card_deck => { :banana => 3 }}
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    before :each do
      authenticate_as @users[0]
    end

    describe 'with valid params' do
      it 'updates the requested arena_card_deck' do
        warlock = Hero.find_by_name('warlock')
        shaman = Hero.find_by_name('shaman')
        arena_card_deck = FactoryGirl.create(:arena_card_deck, :user_id => @users[0].id, :hero_id => warlock.id)

        put :update, {:id => arena_card_deck.to_param, :arena_card_deck => { 'hero_id' => shaman.id }}

        arena_card_deck.reload
        expect(arena_card_deck.hero).to eq(shaman)
      end

      it 'assigns the requested arena_card_deck as @arena_card_deck' do
        arena_card_deck = FactoryGirl.create(:arena_card_deck, :user_id => @users[0].id)
        put :update, {:id => arena_card_deck.to_param, :arena_card_deck => valid_attributes}
        assigns(:arena_card_deck).should eq(arena_card_deck)
      end

      it 'redirects to the arena_card_deck' do
        arena_card_deck = FactoryGirl.create(:arena_card_deck, :user_id => @users[0].id)
        put :update, {:id => arena_card_deck.to_param, :arena_card_deck => valid_attributes}
        response.should redirect_to(arena_card_deck)
      end
    end

    describe 'with invalid params' do
      it 'assigns the arena_card_deck as @arena_card_deck' do
        arena_card_deck = FactoryGirl.create(:arena_card_deck, :user_id => @users[0].id)
        # Trigger the behavior that occurs when invalid params are submitted
        ArenaCardDeck.any_instance.stub(:save).and_return(false)
        put :update, {:id => arena_card_deck.to_param, :arena_card_deck => { :banana => 3 }}
        assigns(:arena_card_deck).should eq(arena_card_deck)
      end

      it "re-renders the 'edit' template" do
        arena_card_deck = FactoryGirl.create(:arena_card_deck, :user_id => @users[0].id)
        # Trigger the behavior that occurs when invalid params are submitted
        ArenaCardDeck.any_instance.stub(:save).and_return(false)
        put :update, {:id => arena_card_deck.to_param, :arena_card_deck => { :banana => 3 }}
        response.should render_template('edit')
      end
    end

    describe 'with invalid user' do

      it 'raises error when not the assigned user' do
        authenticate_as @users[1]
        Grant::User.current_user = @users[1]
        warlock = Hero.find_by_name('warlock')
        shaman = Hero.find_by_name('shaman')
        arena_card_deck = nil
        without_grant do
          arena_card_deck = FactoryGirl.create(:arena_card_deck, :user_id => @users[0].id, :hero_id => warlock.id)
        end

        expect {
          put :update, {:id => arena_card_deck.to_param, :arena_card_deck => { 'hero_id' => shaman.id }}
        }.to raise_exception{|error| expect(error).to be_a(Grant::Error)}

        without_grant do
          arena_card_deck.reload
          expect(arena_card_deck.hero).to eq(warlock)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      authenticate_as @users[0]
    end

    it 'destroys the requested arena_card_deck' do
      arena_card_deck = FactoryGirl.create(:arena_card_deck, :user_id => @users[0].id)
      expect {
        delete :destroy, {:id => arena_card_deck.to_param}
      }.to change(ArenaCardDeck, :count).by(-1)
    end

    it 'redirects to the arena_card_decks list' do
      arena_card_deck = FactoryGirl.create(:arena_card_deck, :user_id => @users[0].id)
      delete :destroy, {:id => arena_card_deck.to_param}
      response.should redirect_to(arena_card_decks_url)
    end
  end

end
