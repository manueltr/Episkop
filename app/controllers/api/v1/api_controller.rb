module Api
    module V1
      class ApiController < ActionController::Base
        before_action :set_user
        before_action :check_user, only: %i[ show edit update destroy ]

        def index
            @polls = Poll.all

            render json:@polls
        end

      end
    end
  end