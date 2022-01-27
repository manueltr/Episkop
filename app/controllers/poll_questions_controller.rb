class PollQuestionsController < ApplicationController
  before_action :set_poll_question, only: %i[ show edit update destroy ]
  before_action :set_poll
  before_action :check_user

  layout "poll"

  # GET /poll_questions or /poll_questions.json
  def index
    @poll_questions = @poll.poll_questions
  end

  # GET /poll_questions/1 or /poll_questions/1.json
  def show
  end

  # GET /poll_questions/new
  def new
    @poll_question = @poll.poll_questions.new
  end

  # GET /poll_questions/1/edit
  def edit
  end

  # POST /poll_questions or /poll_questions.json
  def create
    @poll_question = @poll.poll_questions.new(poll_question_params)

    respond_to do |format|
      if @poll_question.save
        format.html { redirect_to poll_path(@poll), notice: "Poll question was successfully created." }
        format.json { render :show, status: :created, location: @poll_question }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @poll_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /poll_questions/1 or /poll_questions/1.json
  def update
    respond_to do |format|
      if @poll_question.update(poll_question_params)
        format.html { redirect_to poll_path(@poll), notice: "Poll question was successfully updated." }
        format.json { render :show, status: :ok, location: @poll_question }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @poll_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /poll_questions/1 or /poll_questions/1.json
  def destroy
    @poll_question.destroy

    respond_to do |format|
      format.html { redirect_to  poll_poll_questions_path(@poll), notice: "Poll question was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_poll
      if params[:poll_id]
        @poll = Poll.find(params[:poll_id])
      else
        @poll = @poll_question.poll
      end
    end

    def check_user

      # !change, temporary later on the owner of a poll can allow access to modify a poll
      if @poll.user_id != session[:user_id]
        flash[:warning] = "That poll doesn't belong to you!"
        redirect_to "/homepage"
      end
      
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_poll_question
      if @poll
        @poll_question = @poll.poll_questions.find(params[:id])
      else
        @poll_question = PollQuestion.find(params[:id])
      end
    end

    # Only allow a list of trusted parameters through.
    def poll_question_params
      params.require(:poll_question).permit(:question_type, :content)
    end
end
