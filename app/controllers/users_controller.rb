class UsersController < ApplicationController
    def destroy
        @user = User.find(params[:id])
        @user.destroy
        render :nothing => true
    end
end
