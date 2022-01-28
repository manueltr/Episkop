class PollAnswersController < ApplicationController
  before_action :set_poll_answer, only: %i[ edit update destroy ]

  # GET /poll_answers or /poll_answers.json
  # def index
  #   @poll_answers = PollAnswer.all
  # end

  # GET /poll_answers/1 or /poll_answers/1.json
  # def show
  # end

  # GET /poll_answers/new
  def new
    @poll_answer = PollAnswer.new
  end

  # GET /poll_answers/1/edit
  def edit
  end

  # POST /poll_answers or /poll_answers.json
  def create
    @poll_answer = PollAnswer.new(poll_answer_params)

    respond_to do |format|
      if @poll_answer.save
        format.html { redirect_to poll_answer_url(@poll_answer), notice: "Poll answer was successfully created." }
        format.json { render :show, status: :created, location: @poll_answer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @poll_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /poll_answers/1 or /poll_answers/1.json
  def update
    respond_to do |format|
      if @poll_answer.update(poll_answer_params)
        format.html { redirect_to poll_answer_url(@poll_answer), notice: "Poll answer was successfully updated." }
        format.json { render :show, status: :ok, location: @poll_answer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @poll_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /poll_answers/1 or /poll_answers/1.json
  def destroy
    @poll_answer.destroy

    respond_to do |format|
      format.html { redirect_to poll_answers_url, notice: "Poll answer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll_answer
      @poll_answer = PollAnswer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def poll_answer_params
      params.require(:poll_answer).permit(:content)
    end
end
