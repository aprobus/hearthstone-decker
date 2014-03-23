json.array!(@arena_card_decks) do |arena_card_deck|
  json.extract! arena_card_deck, :id
  json.url arena_card_deck_url(arena_card_deck, format: :json)
end
