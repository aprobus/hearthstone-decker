json.array!(@game_imports) do |game_import|
  json.extract! game_import, :id, :card_deck_id, :import_type
  json.url game_import_url(game_import, format: :json)
end
