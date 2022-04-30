class DirectoriesController < ApplicationController
    before_action :set_user, :set_parent

    def create
        @directory = @user.directories.new(directory_params)
        @directory.parent_id = @parent.id

        @children = @parent.children
        respond_to  do |format|
            
            if @directory.save
                format.json {render json: {status: "success"}}
                format.js 
            else
                format.json { render json: @poll.errors, status: :unprocessable_entity }
                format.js { head :ok, status: :unprocessable_entity}
            end
        end
    end

    
    def show
        @directory = @user.directories.find(params[:id])
        @children = @directory.children
        @polls = @directory.polls
        session[:directory] = @directory.id

        respond_to do |format| 
            format.js {render "application/directory"}
        end
    end

    def destroy
        @directory = @user.directories.find(params[:id])
        @children = @directory.children.count
        @polls = @directory.polls.count

        respond_to do |format|
            if ((@children!=0 || @polls!=0) && (params[:destroy] != "true"))
                format.json {render json: {status: "Directory is not empty", type: "warning"}}
            else
                @directory.destroy
                format.json {render json: {status: "Directory has been destroyed!", type: "success"}}
            end
        end
    end

    def update
        
        @directory = @user.directories.find(params[:id])
        respond_to do |format|
            if @directory.update(directory_params)
                format.json {render json: {status: "Success, update directory name", type:"success"}}
            else
                format.json {render json: {type: "error"}, status: :unprocessable_entity}
            end
        end
      end


    private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
        @user = User.find(session[:user_id])
    end

    def set_parent
        @parent = Directory.find(session[:directory])
    end

    # Only allow a list of trusted parameters through.
    def directory_params
      params.require(:directory).permit(:name)
    end
end