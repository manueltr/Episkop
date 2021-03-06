class PollQuestionsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_poll_question, only: %i[ results show edit update destroy write_json write_csv]
  before_action :set_poll
  before_action :check_api
  before_action :check_user, only: %i[ show edit update destroy ]
  require 'csv'
  layout "poll"

  # GET /poll_questions or /poll_questions.json
  # def index
  #   @poll_questions = @poll.poll_questions
  # end

  # /oll_questions/1.json
  def show
    @poll_answers = @poll_question.poll_answers
    @permission = has_edit_permission()
    respond_to do |format|
      if !@permission
        format.json { render :json => {status: "You do not own the data you are trying to access"}, status: :unauthorized }
      else
        format.json
      end
    end 
  end

  def results
    respond_to do |format|
      if @api_key && !@api_key.edit_key
        format.json { render :json => {status: "Not an edit key"}, status: :unauthorized }
      elsif @api_key && !@api_key.accepted
        format.json { render :json =>  {status: "This key has not been accepted"}, status: :unauthorized }
      end

      format.json {render :results}
    end
  end

  def write_json
    json_data = JSON.parse(render_to_string(template: 'poll_questions/results', locals: {poll_question: @poll_question}))
    respond_to do |format|
      format.json {send_data json_data.to_json, poll_question: @poll_question, type: :json, disposition: "attachment", filename: "result.json"}
    end
  end

  def write_csv
    @graph_type = params[:graph_type]
    
    respond_to do |format|
      format.html{ render(:text => "not implemented") }
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Dispostiion'] = "attachment; filename=results.csv"
        if(@graph_type == 'Table')
          render template: "polls/input", locals: {poll_question: @poll_question}
        else
          render template: "polls/multiple", locals: {poll_question: @poll_question}
        end
      end
    end
  end

  # GET /poll_questions/yes_no_graph
  def yesNo

    @graph_type = params[:graph_type]
    questions = params[:questions].split(',').map(&:to_i)
    votes = PollQuestion.select("poll_votes.user_id, poll_answers.content, count(poll_votes.id)").joins(poll_answers: :poll_votes).where('poll_questions.id IN (?)', questions).group(["poll_votes.user_id", "poll_answers.content"]).to_sql()
    records_array = ActiveRecord::Base.connection.execute(votes)
    @results = {}
    @barResults = {}
    @domain = [-questions.length, questions.length]

    records_array.each do |tuple|
      if !@results.key?(tuple["user_id"])
        @results[tuple["user_id"]] = 0
      end
      if tuple["content"] == "Yes"
        @results[tuple["user_id"]] += tuple["count"]
      else
        @results[tuple["user_id"]] -= tuple["count"]
      end
    end

    
    if @graph_type == "Yes no bar graph"

      (@domain[0]..@domain[1]).each do |key|
        @barResults[key] = 0
      end

      @results.each do |key, val|
        @barResults[val] += 1
      end
    end

    respond_to do |format|
      format.json {render "yes_no"}
    end 
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
    @permission = has_edit_permission()

    respond_to do |format|
      if !@permission
        format.json { render :json => {status: "You do not own the data you are trying to access"}, status: :unauthorized }
      elsif @api_key && !@api_key.edit_key
        format.json { render :json => {status: "Not an edit key"}, status: :unauthorized }
      elsif @api_key && !@api_key.accepted
        format.json { render :json => {status: "This key has not been accepted"}, status: :unauthorized }
      elsif @poll_question.save
        #create a poll graph
        @poll_graph = @poll.poll_graphs.new
        @poll_graph.questions = @poll_question.id.to_s
    
        if @poll_question.question_type == "Input"
          @poll_graph.graph_type = "Table"
        elsif @poll_question.question_type == "Yes No"
          @poll_graph.graph_type = "Pie chart"
        else
          @poll_graph.graph_type = "Bar graph"
        end
        @poll_graph.save

        if @api_key
          format.json { render :show, status: :created, location: @poll_question }
        else
          format.html { redirect_to poll_main_page_url(@poll.invite_token), notice: "Poll question was successfully created." }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @poll_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /poll_questions/1 or /poll_questions/1.json
  def update
    @poll_answers = @poll_question.poll_answers
    @permission = has_edit_permission()

    respond_to do |format|
      if !@permission
        format.json { render :json => {status: "You do not own the data you are trying to access"}, status: :unauthorized }
      elsif !session[:user_id] && @api_key && !@api_key.edit_key
        format.json { render :json => {status: "Not an edit key"}, status: :unauthorized }
      elsif @api_key && !@api_key.accepted
        format.json { render :json => {status: "This key has not been accepted"}, status: :unauthorized }
      elsif @poll_question.update(poll_question_edit_params)
        if @api_key
          format.json { render :show, status: :ok, location: @poll_question }
        else
          format.json { render :show, status: :ok, location: @poll_question }
          format.html { redirect_to poll_main_page_url(@poll.invite_token), notice: "Poll question was successfully updated." }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @poll_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /poll_questions/1 or /poll_questions/1.json
  def destroy
    @poll_question.poll.poll_graphs.where("questions like ?", "%"+@poll_question.id.to_s+"%").destroy_all
    @permission = has_edit_permission()
    if (@api_key && @api_key.edit_key && @api_key.accepted && @permission) || session[:user_id]
      @poll_question.destroy
    end

    respond_to do |format|
      if @api_key && @api_key.edit_key && @api_key.accepted
        format.json { render :json => {status: "Successfully deleted question" } }
      elsif !@permission
        format.json { render :json => {status: "You do not own the data you are trying to access"}, status: :unauthorized }
      elsif @api_key && !@api_key.edit_key
        format.json { render :json => {status: "Not a delete key"}, status: :unauthorized }
      elsif @api_key && !@api_key.accepted
        format.json { render :json => {status: "This key has not been accepted"}, status: :unauthorized }
      else
        format.html { redirect_to  poll_main_page_url(@poll.invite_token), notice: "Poll question was successfully destroyed." }
        format.json { head :no_content }
      end
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

    def has_edit_permission
      if @api_key
        return @poll.user_id == @api_key.user_id
      end
      return @poll.user_id == session[:user_id]
    end

    def check_user

      # !change, temporary later on the owner of a poll can allow access to modify a poll
      if (@poll.user_id != session[:user_id]) && (@poll.user_id != @api_key.user_id)
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

    def poll_question_edit_params
      params.require(:poll_question).permit( :content)
    end

    def check_api
      
      @user = nil
      @api_key = nil
      api_key = request.headers["ApiKey"]
  
      if api_key
        @api_key = ApiKey.where(api_token: api_key)[0]
        user_id = @api_key.user_id
        @user = User.find(user_id)
      end
    end
end
