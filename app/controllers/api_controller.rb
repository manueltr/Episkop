class ApiController < ApplicationController

  def index
      @polls = Poll.all

      render json:@polls
  end

end
