class PollsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_user
  before_action :set_poll, only: %i[ main show edit update destroy settings]
  before_action :check_user, only: %i[ edit update destroy show ]

  layout "poll"

  # invitation method
  def send_email_invite
    @user = User.find(session[:user_id])
    @poll = Poll.find(params[:id])
    UserMailer.poll_invite_email(@user, @poll).deliver_now
    flash[:notice] = "Email invite successfully sent."
    redirect_to logged_in_path
  end

  # GET /polls/:invite_token/form
  def form

    @poll = Poll.find_by(invite_token: params[:invite_token])
    @poll_questions = @poll.poll_questions

    # check whether the form is closed
    @form_closed = @poll.is_closed?
    @has_voted = PollVote.where(user_id: @user.id, poll_id: @poll.id).count
    @resubmit_closed = (!@poll.resubmits && @has_voted != 0 && @poll.user_id != @user.id)


  end

  # GET /polls or /polls.json
  def index
    @polls = Poll.all
  end

  # GET /polls/1 or /polls/1.json
  def show
    @poll_questions = @poll.poll_questions
    @permission = has_edit_permission()

    respond_to  do |format|
             
        if @api_key && @api_key.extract_key && @api_key.accepted
          format.json { render :show, status: :ok }
        elsif @api_key && !@api_key.accepted
          format.json { render :json => {status: "This key has not been accepted"}, status: :unauthorized }
        else
          format.json { render :json => {status: "Not an extract key"}, status: :unauthorized }
        end
    end
  end

  
  # GET /polls/:invite_token/main
  def main
    @poll_questions = @poll.poll_questions
    @permission = has_edit_permission()

    #check if poll is closed
    @form_closed = @poll.is_closed?
    @has_voted = PollVote.where(user_id: @user.id, poll_id: @poll.id).count
    @resubmit_closed = (!@poll.resubmits && @has_voted != 0 && @poll.user_id != @user.id)

    respond_to  do |format|       
      format.html {render "main"}
      format.js {render "edit_view"}
    end
  end

  # Get /polls/:invite_token/settings.js
  def settings
    @permission = has_edit_permission

    respond_to do |format|
      format.js
    end

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

    if session[:user_id]
      @poll.directory_id = session[:directory]
    elsif !params[:directory_id]
      @poll.directory_id = @user.directories.where(name: "root")[0].id
    end


    respond_to do |format|
      if !session[:user_id] && @api_key && !@api_key.create_key
        format.json { render :json => {status: "Not a create key"}, status: :unauthorized }
      elsif @api_key && !@api_key.accepted
        format.json { render :json => {status: "This key has not been accepted"}, status: :unauthorized }
      elsif @poll.save
        flash[:notice] = "Poll was successfully created."
        format.html { redirect_to "/homepage" }
        format.js
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
      if !session[:user_id] && @api_key && !@api_key.edit_key
        format.json { render :json => {status: "Not an edit key"}, status: :unauthorized }
      elsif @api_key && !@api_key.accepted
        format.json { render :json => {status: "This key has not been accepted"}, status: :unauthorized }
      else
        if @poll.update(poll_params)
          if @api_key
            format.json { render :show, status: :ok, location: @poll }
          else 
            format.html { redirect_to poll_main_page_url(@poll.invite_token)}
          end
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @poll.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /polls/1 or /polls/1.json
  def destroy

    respond_to do |format|

      # response for api key
      if @api_key
       if !@api_key.delete_key
        format.json { render :json => {status: "Not a delete key"}, status: :unauthorized }
       else
        @poll.destroy
        format.json { render :json => {status: "Successfully deleted poll", id: @poll.id, title: @poll.title} }
       end

      else
        
        #check if poll has question in it
        poll_question_count = @poll.poll_questions.count
  
        if poll_question_count && (params[:delete] != "true")
          format.json { render json: {status: "Poll is not empty", type:"warning"}}
        else 
          @poll.destroy
          format.json { render json: {status: "Successfully deleted poll", type:"success"}}
        end
      end
    end
  end


  def results

    @poll = Poll.find_by(invite_token: params[:invite_token])
    @is_users = @poll.user_id == @user.id

    @results_closed = (!@poll.show_results && (@poll.user_id != @user.id))
    @poll_graphs = @poll.poll_graphs
    @poll_questions = @poll.poll_questions
    
    respond_to  do |format|
            
      format.html { render 404}
      format.js
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_poll

      #if the poll id is not provided, attempt to use the invite_token
      if params[:id]
        @poll = Poll.find(params[:id])
      elsif
        @poll = Poll.find_by(invite_token: params[:invite_token])
      end

    end

    def set_user

      @api_key = nil
      @user = nil
      api_key = request.headers["ApiKey"]

      # first attempt to set the user through the session, else use the api token provided
      # the function never gets to this point without one of them true since the route is authenticated
      if session[:user_id]
        @user = User.find(session[:user_id])
      elsif api_key
        @api_key = ApiKey.where(api_token: api_key)[0]
        user_id = @api_key.user_id
        @user = User.find(user_id)
      end
      
      @profile_picture = @user.photo
      @name = @user.username
    end

    def check_user

      #ensure that the poll belongs to the user who is trying to modify it
      if @api_key == nil && @poll.user_id != session[:user_id]
        flash[:warning] = "That poll doesn't belong to you!"
        redirect_to "/homepage"
      end

    end


    def has_edit_permission
      return @poll.user_id == session[:user_id]
    end


    # Only allow a list of trusted parameters through.
    def poll_params
      params.require(:poll).permit(:title, :summary, :opened, :publish, :ends_at, :directory_id, :anonymous, :show_results, :resubmits)
    end
end
