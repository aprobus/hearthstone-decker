# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

warlock = Hero.create(:name => 'warlock')
shaman = Hero.create(:name => 'shaman')
hunter = Hero.create(:name => 'hunter')
warrior = Hero.create(:name => 'warrior')
mage = Hero.create(:name => 'mage')
druid = Hero.create(:name => 'druid')
rogue = Hero.create(:name => 'rogue')
paladin = Hero.create(:name => 'paladin')
