
warlock = Hero.find_by_name('warlock') || Hero.create!(:name => 'warlock')
shaman = Hero.find_by_name('shaman') || Hero.create!(:name => 'shaman')
hunter = Hero.find_by_name('hunter') || Hero.create!(:name => 'hunter')
warrior = Hero.find_by_name('warrior') || Hero.create!(:name => 'warrior')
mage = Hero.find_by_name('mage') || Hero.create!(:name => 'mage')
druid = Hero.find_by_name('druid') || Hero.create!(:name => 'druid')
rogue = Hero.find_by_name('rogue') || Hero.create!(:name => 'rogue')
paladin = Hero.find_by_name('paladin') || Hero.create!(:name => 'paladin')
priest = Hero.find_by_name('priest') || Hero.create!(:name => 'priest')

