FactoryGirl.define do
  factory :regular_card_deck do
    user User.first
    name 'Test deck'
    hero Hero.first
  end

  factory :arena_card_deck do
    user User.first
    hero Hero.first
  end
end
