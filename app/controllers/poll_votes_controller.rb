require "rqrcode"

class PollVotesController < ApplicationController
  layout "poll"

  # POST /polls/:invite_token/submit?form_params
  def submit
    
    #handle the creation for vote_answers here!
    @poll = Poll.find_by(:invite_token => params[:invite_token])
    params.each do |question, answer|

      if question.match('question_')
        question_id = question.scan(/\d+/)[0]
        @poll_question = PollQuestion.find(question_id)

        @poll_vote = PollVote.find_or_create_by(:user_id => session[:user_id], :poll_id => @poll.id, :poll_question_id => @poll_question.id)

        # can only go from false to true for future implementation
        @poll_vote.submitted = true
      
        if @poll_question.question_type == "Input"

          @poll_vote.response = answer
          @poll_vote.poll_answer_id = nil
        else

          @poll_vote.poll_answer_id = answer.scan(/\d+/)[0]
          @poll_vote.response = nil
        end

        @poll_vote.save
      else
        break
      end

    end

    redirect_to logged_in_path
  end

  #GET /polls/:invite_token/qr_code
  def qr
    qrcode = RQRCode::QRCode.new(form_url(params[:invite_token]))

    # NOTE: showing with default options specified explicitly
    @svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true
    )
    
  end
end