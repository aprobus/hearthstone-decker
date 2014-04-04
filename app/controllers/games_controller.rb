class GamesController < ApplicationController

  before_action :set_card_deck, only: [:create]
  before_filter :authenticate_user!

  def create
    @game = @card_deck.add_game do |game|
      game.user = current_user
      game.hero = Hero.find_by_id(params[:game][:hero_id])
      game.assign_attributes(game_params)
    end

    respond_to do |format|
      if @game.persisted?
        format.html { redirect_to @card_deck, notice: 'Game was successfully created.' }
        format.json { render action: 'show', status: :created, location: @card_deck }
      else
        #TODO: Make this more generic
        deck_class_string = @card_deck.class.name.underscore
        template = "/#{deck_class_string.pluralize}/show"
        instance_variable_set("@#{deck_class_string}", @card_deck)

        @heroes = Hero.order(:name => :asc)
        @arena_card_deck = @card_deck
        format.html { render template: template }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    game = Game.find(params[:id])
    card_deck = game.card_deck
    card_deck.delete_game(game)

    redirect_to card_deck
  end

  private

  def set_card_deck
    param_key = params.keys.find do |key|
      key.to_s.include?('card_deck_id')
    end

    @card_deck = CardDeck.find(params[param_key])

    if @card_deck.user_id != current_user.id
      raise ActionController::ForbiddenError.new
    end
  end

  def game_params
    return params.require(:game).permit(:win_ind, :mode)
  end

end
