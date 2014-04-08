module ArenaCardDecksHelper
  def hero_name(model)
    hero_id = nil
    if model.has_attribute? :hero_id
      hero_id = model.hero_id
    else
      hero_id = model.id
    end

    heroes = @heroes || Hero.all
    heroes.find{|hero| hero.id == hero_id }.display_name
  end
end

