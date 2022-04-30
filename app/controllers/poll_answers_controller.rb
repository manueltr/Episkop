class PollAnswersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :check_api
  before_action :set_poll_answer, only: %i[ edit update destroy ]

  layout "poll"
  before_action :set_poll_question, only: %i[new create]
  # GET /poll_answers or /poll_answers.json
  # def index
  #   @poll_answers = PollAnswer.all
  # end

  #GET /poll_answers/1 or /poll_answers/1.json
  # def show
  # end

  # GET /poll_answers/new
  def new
    @poll_answer = @poll_question.poll_answers.new(poll_id: params[:poll_id])
    @question_id_to_add_answer = "#poll_answers" + (@poll_question.id).to_s;
  end

  # GET /poll_answers/1/edit
  # def edit
  # end

  # POST /poll_answers or /poll_answers.json
  def create
    @poll_answer = @poll_question.poll_answers.new(poll_answer_params)
    @poll_answer.poll_id = params[:poll_id]

    @poll = Poll.find(@poll_answer.poll_id)

    respond_to do |format|
      if @api_key && !@api_key.edit_key
        format.json { render :json => {status: "Not an edit key"}, status: :unauthorized }
      elsif @poll_answer.save
        if @api_key
          format.json { render :show, status: :created, location: @poll_answer }
        else
          format.html { redirect_to poll_main_page_url(@poll.invite_token), notice: "Poll answer was successfully created." }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @poll_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /poll_answers/1 or /poll_answers/1.json
  # def update
  #   respond_to do |format|
  #     if @poll_answer.update(poll_answer_params)
  #       format.html { redirect_to poll_answer_url(@poll_answer), notice: "Poll answer was successfully updated." }
  #       format.json { render :show, status: :ok, location: @poll_answer }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @poll_answer.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /poll_answers/1 or /poll_answers/1.json
  def destroy
    @poll = Poll.find(@poll_answer.poll_id)
    if (@api_key && @api_key.delete_key) || session[:user_id]
      @poll_answer.destroy
    end

    respond_to do |format|
      if @api_key && @api_key.delete_key
        format.json { render :json => {status: "Successfully deleted answer" } }
      elsif @api_key && !@api_key.delete_key
        format.json { render :json => {status: "Not a delete key"}, status: :unauthorized }
      else
        format.html { redirect_to , notice: "Poll answer was successfully destroyed." }
        format.json { head :no_content }
      end  
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll_answer
      @poll_answer = PollAnswer.find(params[:id])
    end

    def set_poll_question
      @poll_question = PollQuestion.find(params[:question])
    end

    # Only allow a list of trusted parameters through.
    def poll_answer_params
      params.require(:poll_answer).permit(:content)
    end

    def check_api
      @api_key = nil
      api_key = request.headers["ApiKey"]
      @user = nil
      if api_key
        @api_key = ApiKey.where(api_token: api_key)[0]
        user_id = @api_key.user_id
        @user = User.find(user_id)
      end
    end
end
