class ApiController < ApplicationController

  def index
    @polls = Poll.all

    # ideally, full api would show:
    # poll ->
    #   poll_questions ->
    #     poll_answers ->

    # render json:@polls.includes(:poll_questions)
    render json:@polls
  end

  def index_non_db
    @polls = Poll.all

    render json:@polls, only: [:title, :summary, :opened, :invite_token]
  end

end
