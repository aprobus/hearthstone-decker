FactoryGirl.define do
  factory :card do
    name 'Test Card'
    hero Hero.first
    card_type 'minion'
    mana 1
    health 2
    rarity 'common'
  end
end
