require 'forbidden_error'

class ArenaCardDecksController < ApplicationController
  before_action :set_arena_card_deck, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /arena_card_decks
  # GET /arena_card_decks.json
  def index
    @arena_card_decks = ArenaCardDeck.where(:user_id => current_user.id)
  end

  # GET /arena_card_decks/1
  # GET /arena_card_decks/1.json
  def show

  end

  # GET /arena_card_decks/new
  def new
    @arena_card_deck = ArenaCardDeck.new
  end

  # GET /arena_card_decks/1/edit
  def edit
  end

  # POST /arena_card_decks
  # POST /arena_card_decks.json
  def create
    @arena_card_deck = ArenaCardDeck.new(arena_card_deck_params)
    @arena_card_deck.user = current_user
    @arena_card_deck.hero = Hero.find_by_id(params[:arena_card_deck][:hero_id])

    respond_to do |format|
      if @arena_card_deck.save
        format.html { redirect_to @arena_card_deck, notice: 'Arena card deck was successfully created.' }
        format.json { render action: 'show', status: :created, location: @arena_card_deck }
      else
        format.html { render action: 'new' }
        format.json { render json: @arena_card_deck.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /arena_card_decks/1
  # PATCH/PUT /arena_card_decks/1.json
  def update
    @arena_card_deck.hero = Hero.find_by_id(params[:arena_card_deck][:hero_id])

    respond_to do |format|
      if @arena_card_deck.update(arena_card_deck_params)
        format.html { redirect_to @arena_card_deck, notice: 'Arena card deck was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @arena_card_deck }
      else
        format.html { render action: 'edit' }
        format.json { render json: @arena_card_deck.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /arena_card_decks/1
  # DELETE /arena_card_decks/1.json
  def destroy
    @arena_card_deck.destroy
    respond_to do |format|
      format.html { redirect_to arena_card_decks_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_arena_card_deck
    @arena_card_deck = ArenaCardDeck.find(params[:id])

    if @arena_card_deck.user_id != current_user.id
      raise ActionController::ForbiddenError.new
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def arena_card_deck_params
    params[:arena_card_deck]
    return params.require(:arena_card_deck).permit()
  end

end
