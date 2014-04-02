
warlock = Hero.find_by_name('warlock') || Hero.create!(:name => 'warlock')
shaman = Hero.find_by_name('shaman') || Hero.create!(:name => 'shaman')
hunter = Hero.find_by_name('hunter') || Hero.create!(:name => 'hunter')
warrior = Hero.find_by_name('warrior') || Hero.create!(:name => 'warrior')
mage = Hero.find_by_name('mage') || Hero.create!(:name => 'mage')
druid = Hero.find_by_name('druid') || Hero.create!(:name => 'druid')
rogue = Hero.find_by_name('rogue') || Hero.create!(:name => 'rogue')
paladin = Hero.find_by_name('paladin') || Hero.create!(:name => 'paladin')
priest = Hero.find_by_name('priest') || Hero.create!(:name => 'priest')

user = User.create!(:email => 'test@test.com', :password => '123456789')
user2 = User.create!(:email => 'test1@test.com', :password => '123456789')

Card.create!(:name => 'Rockbiter Weapon', :card_type => 'weapon', :hero_id => shaman.id, 
  :mana => '1', :card_text => 'Give a character +3 attack this turn', :rarity => 'soul_bound')
Card.create!(:name => 'Doomhammer', :card_type => 'weapon', :hero_id => shaman.id,  
  :mana => '5', :card_text => 'Windfury. Overload(2)', :damage => 2, :rarity => 'epic')
Card.create!(:name => 'Earth elemental', :card_type => 'minion', :hero_id => shaman.id, 
  :mana => '5', :card_text => 'Overload(2)', :damage => 7, :health => 8, :rarity => 'epic')
Card.create!(:name => 'Hex', :card_type => 'spell', :hero_id => shaman.id,  
  :mana => '3', :card_text => 'Turn a minion into a 0/1 minion with taunt', :rarity => 'soul_bound')

Card.create!(:name => 'Unleash The Hounds', :card_type => 'spell', :hero_id => hunter.id,  
  :mana => '2', :card_text => 'Summon a 1/1 beast for every minion your opponent has', :rarity => 'soul_bound')

Card.create!(:name => 'Chillwind Yeti', :card_type => 'minion', 
  :mana => '4', :damage => 4, :health => 5, :rarity => 'common')

