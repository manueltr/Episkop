class PollGraphsController < ApplicationController
    before_action :set_user
    before_action :set_poll, only: %i[ create]
  
    layout "poll"
  
    # POST /poll_graphs/:id or /poll_graphs/:id.json
    def create
      @graph = @poll.poll_graphs.new
      @graph.graph_type = params[:graph_type]

      values = params.to_unsafe_h.select{|key, value| key =~ /^yes_no/}
      question_ids = []
      values.each do |key, val|
        question_ids.append(val)
      end


      
      if @graph.graph_type == "Input"
        @graph.questions = params[:input]
      elsif @graph.graph_type == "Yes no beeswarm graph" || @graph.graph_type == "Yes no bar graph"
        @graph.questions = question_ids.join(',')
      else
        @graph.questions = params[:multi]
      end
      
      respond_to do |format|
        if @graph.save
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
  
      # Only allow a list of trusted parameters through.
        #   def poll_params
        #     params.require(:poll).permit(:title, :summary, :opened, :publish, :ends_at)
        #   end
  end
  