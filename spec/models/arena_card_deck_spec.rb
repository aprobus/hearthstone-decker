require 'spec_helper'

describe ArenaCardDeck do

  before :each do
    @user = User.first || User.create!(:email => 'test@test.com', :password => '12345678')
  end

end
