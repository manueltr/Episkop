class PollsController < ApplicationController
  before_action :set_user
  before_action :set_poll, only: %i[ show edit update destroy ]
  before_action :check_user, only: %i[ show edit update destroy ]

  layout "poll"

  # GET /polls or /polls.json
  def index
    @polls = Poll.all
  end

  # GET /polls/1 or /polls/1.json
  def show
    @poll_questions = @poll.poll_questions
  end

  # GET /polls/new
  def new
    @poll = Poll.new
  end

  # GET /polls/1/edit
  def edit
  end

  # POST /polls or /polls.json
  def create
    @poll = @user.polls.new(poll_params)

    respond_to do |format|
      if @poll.save
        flash[:notice] = "Poll was successfully created."
        format.html { redirect_to "/homepage" }
        format.json { render :show, status: :created, location: @poll }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /polls/1 or /polls/1.json
  def update
    respond_to do |format|
      if @poll.update(poll_params)
        format.html { redirect_to poll_url(@poll), notice: "Poll was successfully updated." }
        format.json { render :show, status: :ok, location: @poll }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /polls/1 or /polls/1.json
  def destroy
    @poll.destroy

    respond_to do |format|
      format.html { redirect_to "/homepage", notice: "Poll was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll
      @poll = Poll.find(params[:id])
    end

    def set_user
      @user = User.find(session[:user_id])
      @profile_picture = @user.photo
      @name = @user.username
    end

    def check_user

      # !change, temporary later on the owner of a poll can allow access to modify a poll
      if @poll.user_id != session[:user_id]
        flash[:warning] = "That poll doesn't belong to you!"
        redirect_to "/homepage"
      end

    end


    # Only allow a list of trusted parameters through.
    def poll_params
      params.require(:poll).permit(:title, :summary, :opened, :ends_at)
    end
end