require 'spec_helper'

describe HomeController do

  describe '#index' do
    it 'should do something' do
      get :index

      expect(response).to be_ok
    end
  end
end
