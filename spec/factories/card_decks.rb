FactoryGirl.define do
  factory :regular_card_deck do
    user_id User.first.id
    name 'Test deck'
    hero_id Hero.first.id
    num_games_lost 0
    num_games_won 0
  end

  factory :arena_card_deck do
    user_id User.first.id
    hero_id Hero.first.id
    num_games_lost 0
    num_games_won 0
  end
end
