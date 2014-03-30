require 'spec_helper'

describe RegularCardDecksController do
  include Grant::Status

  # This should return the minimal set of attributes required to create a valid
  # RegularCardDeck. As you add validations to RegularCardDeck, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { :hero_id => Hero.first.id, :name => 'Test Deck' } }

  before :all do
    @users = [
      User.first || User.create!(:email => 'test1@test.com', :password => '12345678'),
      User.second || User.create!(:email => 'test2@test.com', :password => '12345678')
    ]

    without_grant do
      @decks = [
          FactoryGirl.create(:regular_card_deck, :name => 'Test1', :user_id => @users[0].id),
          FactoryGirl.create(:regular_card_deck, :name => 'Test2', :user_id => @users[1].id)
      ]
    end
  end

  describe 'GET index' do
    it 'assigns all regular_card_decks as @regular_card_decks' do
      authenticate_as @users[0]
      get :index, {}
      expect(response).to be_ok
      assigns(:regular_card_decks).each do |deck|
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

    it 'assigns the requested regular_card_deck as @regular_card_deck' do
      authenticate_as @users[0]
      get :show, {:id => @decks[0].id.to_param}
      expect(assigns(:regular_card_deck)).to eq(@decks[0])
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
    it 'assigns a new regular_card_deck as @regular_card_deck' do
      authenticate_as @users[0]
      get :new
      expect(assigns(:regular_card_deck)).to be_a_new(RegularCardDeck)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested regular_card_deck as @regular_card_deck' do
      authenticate_as @users[0]
      regular_card_deck = FactoryGirl.create(:regular_card_deck, :user_id => @users[0].id)
      get :edit, {:id => regular_card_deck.to_param}
      expect(assigns(:regular_card_deck)).to eq(regular_card_deck)
    end
  end

  describe 'POST create' do
    before :each do
      authenticate_as @users[0]
    end

    describe 'with valid params' do
      it 'creates a new RegularCardDeck' do
        expect {
          post :create, {:regular_card_deck => valid_attributes}
        }.to change(RegularCardDeck, :count).by(1)
      end

      it 'assigns a newly created regular_card_deck as @regular_card_deck' do
        post :create, {:regular_card_deck => valid_attributes}
        assigns(:regular_card_deck).should be_a(RegularCardDeck)
        assigns(:regular_card_deck).should be_persisted
      end

      it 'redirects to the created regular_card_deck' do
        post :create, {:regular_card_deck => valid_attributes}
        response.should redirect_to(RegularCardDeck.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved regular_card_deck as @regular_card_deck' do
        # Trigger the behavior that occurs when invalid params are submitted
        RegularCardDeck.any_instance.stub(:save).and_return(false)
        post :create, {:regular_card_deck => { :banana => 3 }}
        assigns(:regular_card_deck).should be_a_new(RegularCardDeck)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        RegularCardDeck.any_instance.stub(:save).and_return(false)
        post :create, {:regular_card_deck => { :banana => 3 }}
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    before :each do
      authenticate_as @users[0]
    end

    describe 'with valid params' do
      it 'updates the requested regular_card_deck' do
        warlock = Hero.find_by_name('warlock')
        shaman = Hero.find_by_name('shaman')
        regular_card_deck = FactoryGirl.create(:regular_card_deck, :user_id => @users[0].id, :hero_id => warlock.id)

        put :update, {:id => regular_card_deck.to_param, :regular_card_deck => { 'hero_id' => shaman.id }}

        regular_card_deck.reload
        expect(regular_card_deck.hero).to eq(shaman)
      end

      it 'assigns the requested regular_card_deck as @regular_card_deck' do
        regular_card_deck = FactoryGirl.create(:regular_card_deck, :user_id => @users[0].id)
        put :update, {:id => regular_card_deck.to_param, :regular_card_deck => valid_attributes}
        assigns(:regular_card_deck).should eq(regular_card_deck)
      end

      it 'redirects to the regular_card_deck' do
        regular_card_deck = FactoryGirl.create(:regular_card_deck, :user_id => @users[0].id)
        put :update, {:id => regular_card_deck.to_param, :regular_card_deck => valid_attributes}
        response.should redirect_to(regular_card_deck)
      end
    end

    describe 'with invalid params' do
      it 'assigns the regular_card_deck as @regular_card_deck' do
        regular_card_deck = FactoryGirl.create(:regular_card_deck, :user_id => @users[0].id)
        # Trigger the behavior that occurs when invalid params are submitted
        RegularCardDeck.any_instance.stub(:save).and_return(false)
        put :update, {:id => regular_card_deck.to_param, :regular_card_deck => { :banana => 3 }}
        assigns(:regular_card_deck).should eq(regular_card_deck)
      end

      it "re-renders the 'edit' template" do
        regular_card_deck = FactoryGirl.create(:regular_card_deck, :user_id => @users[0].id)
        # Trigger the behavior that occurs when invalid params are submitted
        RegularCardDeck.any_instance.stub(:save).and_return(false)
        put :update, {:id => regular_card_deck.to_param, :regular_card_deck => { :banana => 3 }}
        response.should render_template('edit')
      end
    end

    describe 'with invalid user' do

      it 'raises error when not the assigned user' do
        authenticate_as @users[1]
        Grant::User.current_user = @users[1]
        warlock = Hero.find_by_name('warlock')
        shaman = Hero.find_by_name('shaman')
        regular_card_deck = nil
        without_grant do
          regular_card_deck = FactoryGirl.create(:regular_card_deck, :user_id => @users[0].id, :hero_id => warlock.id)
        end

        expect {
          put :update, {:id => regular_card_deck.to_param, :regular_card_deck => { 'hero_id' => shaman.id }}
        }.to raise_exception{|error| expect(error).to be_a(Grant::Error)}

        without_grant do
          regular_card_deck.reload
          expect(regular_card_deck.hero).to eq(warlock)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      authenticate_as @users[0]
    end

    it 'destroys the requested regular_card_deck' do
      regular_card_deck = FactoryGirl.create(:regular_card_deck, :user_id => @users[0].id)
      expect {
        delete :destroy, {:id => regular_card_deck.to_param}
      }.to change(RegularCardDeck, :count).by(-1)
    end

    it 'redirects to the regular_card_decks list' do
      regular_card_deck = FactoryGirl.create(:regular_card_deck, :user_id => @users[0].id)
      delete :destroy, {:id => regular_card_deck.to_param}
      response.should redirect_to(regular_card_decks_url)
    end

    it 'removes related games' do
      regular_card_deck = FactoryGirl.create(:regular_card_deck, :user_id => @users[0].id)
      game = regular_card_deck.add_game do |game|
        game.win_ind = true
        game.mode = 'normal'
        game.hero_id = Hero.first.id
        game.user = @users[0]
      end
      expect(game).to be_persisted

      expect {
        delete :destroy, {:id => regular_card_deck.to_param}
      }.to change(RegularCardDeck, :count).by(-1)

      expect(Game.exists?(game)).to be_false
    end
  end

end
