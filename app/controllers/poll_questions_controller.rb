class PollQuestionsController < ApplicationController
  before_action :set_poll_question, only: %i[ show edit update destroy ]

  # GET /poll_questions or /poll_questions.json
  def index
    @poll_questions = PollQuestion.all
  end

  # GET /poll_questions/1 or /poll_questions/1.json
  def show
  end

  # GET /poll_questions/new
  def new
    @poll_question = PollQuestion.new
  end

  # GET /poll_questions/1/edit
  def edit
  end

  # POST /poll_questions or /poll_questions.json
  def create
    @poll_question = PollQuestion.new(poll_question_params)

    respond_to do |format|
      if @poll_question.save
        format.html { redirect_to poll_question_url(@poll_question), notice: "Poll question was successfully created." }
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
        format.html { redirect_to poll_question_url(@poll_question), notice: "Poll question was successfully updated." }
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
      format.html { redirect_to poll_questions_url, notice: "Poll question was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll_question
      @poll_question = PollQuestion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def poll_question_params
      params.require(:poll_question).permit(:type, :content)
    end
end
