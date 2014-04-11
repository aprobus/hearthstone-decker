class CardDecksBaseController < ApplicationController

  before_action :set_card_deck, only: [:show, :edit, :update, :destroy]
  before_action :set_heroes, only: [:show, :edit, :update, :new]
  before_filter :authenticate_user!
  before_filter :set_active_tab

  def controller_model
    raise 'Must override this method!'
  end

  def editable_fields
    []
  end

  def index
    decks = controller_model.where(:user_id => current_user.id).order(:created_at => :desc).page(params[:page])
    instance_variable_set("@#{models_sym}", decks)
  end

  def show
    @game = Game.new
  end

  def new
    instance_variable_set("@#{model_sym}", controller_model.new)
  end

  def edit
  end

  def create
    card_deck = controller_model.new(card_deck_params)
    instance_variable_set("@#{model_sym}", card_deck)
    card_deck.user = current_user
    card_deck.hero = Hero.find_by_id(model_params[:hero_id])

    respond_to do |format|
      if card_deck.save
        format.html { redirect_to card_deck, notice: 'Deck was successfully created.' }
        format.json { render action: 'show', status: :created, location: card_deck }
      else
        format.html { render action: 'new' }
        format.json { render json: card_deck.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    card_deck = instance_variable_get("@#{model_sym}")
    card_deck.hero = Hero.find_by_id(model_params[:hero_id])

    respond_to do |format|
      if card_deck.update(card_deck_params)
        format.html { redirect_to card_deck, notice: 'Deck was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: card_deck }
      else
        format.html { render action: 'edit' }
        format.json { render json: card_deck.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    instance_variable_get("@#{model_sym}").destroy
    respond_to do |format|
      format.html { redirect_to send("#{models_sym}_url") }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_card_deck
    instance_variable_set("@#{model_sym}", controller_model.find(params[:id]))
  end

  def set_heroes
    @heroes = Hero.order(:name => :asc)
  end

  def model_params
    return params.require(model_sym)
  end

  def card_deck_params
    return model_params.permit(editable_fields)
  end

  def set_active_tab
    @active_tab = model_sym
  end

  def model_sym
    controller_model.name.underscore.to_sym
  end

  def models_sym
    controller_model.name.underscore.pluralize.to_sym
  end
end

