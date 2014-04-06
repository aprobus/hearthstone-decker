Rails.application.routes.draw do
  resources :game_imports, :only => [:create, :destroy, :show, :index, :new]

  devise_for :users

  get 'arena_card_decks/stats' => 'arena_card_decks#stats'
  resources :arena_card_decks do
    resources :games, :shallow => true, :only => [:create, :destroy]
  end

  resources :regular_card_decks do
    resources :games, :shallow => true, :only => [:create, :destroy]
  end

  root :to => 'home#index'
end

