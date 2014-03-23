class GamesController < ApplicationController

  before_action :set_card_deck, only: [:create]
  before_filter :authenticate_user!

  def create
    @game = Game.new(game_params)
    @game.user = current_user
    @game.hero = Hero.find_by_id(params[:game][:hero_id])
    @game.card_deck = @card_deck

    respond_to do |format|
      if @game.save!
        format.html { redirect_to @card_deck, notice: 'Game was successfully created.' }
        format.json { render action: 'show', status: :created, location: @card_deck }
      else
        format.html { render action: 'new' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_card_deck
    @card_deck = CardDeck.find(params[:arena_card_deck_id])

    if @card_deck.user_id != current_user.id
      raise ActionController::ForbiddenError.new
    end
  end

  def game_params
    return params.require(:game).permit(:win_ind, :mode)
  end

end