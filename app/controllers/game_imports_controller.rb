require 'game_file_parser/csv'

class GameImportsController < ApplicationController

  before_action :set_active_tab
  before_action :set_game_import, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  FILE_PARSERS = [GameFileParser::Csv]

  # GET /game_imports
  # GET /game_imports.json
  def index
    @game_imports = current_user.game_imports.order(:created_at => :desc)
  end

  # GET /game_imports/1
  # GET /game_imports/1.json
  def show
  end

  # GET /game_imports/new
  def new
    @game_import = GameImport.new
    @import_errors = []
  end

  # GET /game_imports/1/edit
  def edit
  end

  # POST /game_imports
  # POST /game_imports.json
  def create
    @import_errors = []

    user_file = uploaded_file
    user_filename = user_file.nil? ? '' : user_file.original_filename
    if !user_file.nil?
      logger.info "User #{current_user.email} uploaded file #{user_file.class.name} with size #{user_file.size} bytes"

      parser = FILE_PARSERS.find do |parser|
        parser.can_parse?(user_file.content_type)
      end

      if parser.nil?
        @import_errors << 'Unable to parse file'
      else
        parser_instance = parser.new(user_file.tempfile, current_user)
        @game_import, @import_errors = parser_instance.process do |game_import|
          game_import.file_name = user_filename
        end
      end
    else
      @import_errors << 'No file given'
    end

    respond_to do |format|
      if !@game_import.nil?
        format.html { redirect_to @game_import, notice: 'Game import was successfully created.' }
        format.json { render action: 'show', status: :created, location: @game_import }
      else
        @game_import = GameImport.new
        @game_import.file_name = user_filename
        format.html { render action: 'new' }
        format.json { render json: @game_import.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_imports/1
  # DELETE /game_imports/1.json
  def destroy
    @game_import.destroy
    respond_to do |format|
      format.html { redirect_to game_imports_url }
      format.json { head :no_content }
    end
  end

  private

  def uploaded_file
    if params[:game_import] && params[:game_import][:file] && params[:game_import][:file].respond_to?(:original_filename)
      return params[:game_import][:file]
    else
      return nil
    end
  end

  def set_active_tab
    @active_tab = :game_imports
  end

  def set_game_import
    @game_import = GameImport.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def game_import_params
    #params.require(:game_import).permit()
    {}
  end
end

