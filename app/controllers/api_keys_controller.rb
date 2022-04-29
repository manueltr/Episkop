class ApiKeysController < ApplicationController
  before_action :set_user
  before_action :set_api_key, only: %i[ show edit update destroy ]
  layout "poll"

  # GET /api_keys or /api_keys.json
  # def index
  #   @api_keys = ApiKey.all
  # end

  # API Keys on settings page
  # def my_keys
  #   @api_keys = ApiKey.all
  # end

  # GET /api_keys/1 or /api_keys/1.json
  # def show
  # end

  # GET /api_keys/new
  def new
    @api_key = ApiKey.new
  end

  # GET /api_keys/1/edit
  # def edit
  # end

  # POST /api_keys or /api_keys.json
  def create
    @api_key = @user.api_keys.new(api_key_params)

    @api_key.in_req_mode = true;
    @api_key.accepted = nil;
    
    respond_to do |format|
      if @api_key.save
        format.html { redirect_to settings_path, notice: "Your request for an API Key has been received! Be on the lookout for an email." }
        format.json { render :show, status: :created, location: @api_key }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @api_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api_keys/1 or /api_keys/1.json
  def update
    respond_to do |format|
      if @api_key.update(api_key_params)
        format.html { redirect_to settings_path, notice: "Api key was successfully updated." }
        format.json { render :show, status: :ok, location: @api_key }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @api_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api_keys/1 or /api_keys/1.json
  def destroy
    @api_key.destroy

    respond_to do |format|
      format.html { redirect_to settings_path, notice: "Api key was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(session[:user_id])
      @profile_picture = @user.photo
      @name = @user.username
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_api_key
      @api_key = ApiKey.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def api_key_params
      params.require(:api_key).permit(:create_key, :delete_key, :extract_key, :edit_key, :in_req_mode, :accepted, :explanation)
    end
end
