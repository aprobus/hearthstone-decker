require 'spec_helper'

describe GameImportsController do
  include Grant::Status

  before :each do
    @user = User.first
    authenticate_as @user

    @other_user = User.second
    without_grant do
      GameImport.create!(:user => @other_user, :file_name => 'test.csv') 
    end
  end

  describe 'GET index' do
    it 'should list imports' do
      game_import = GameImport.create!(:user => @user, :file_name => 'test.csv') 

      get :index

      imports = assigns(:game_imports)
      expect(imports).to eq([game_import])
    end
  end

  describe 'GET new' do
    it 'should set attributes' do
      get :new

      expect(assigns(:game_import)).not_to be_nil
    end 
  end

  describe 'GET show' do
    it 'should set attributes' do
      game_import = GameImport.create!(:user => @user, :file_name => 'test.csv') 

      get :show, { :id => game_import.id }

      import = assigns(:game_import)
      expect(import).to eq(game_import)
    end

    it 'should not show imports from other users' do
      game_import = GameImport.create!(:user => @user, :file_name => 'test.csv') 

      authenticate_as @other_user
      expect {
        get :show, { :id => game_import.id }
      }.to raise_error
    end

  end

end

