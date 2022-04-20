class SessionsController < ApplicationController
  skip_before_action :require_login
  
  # def new
  # end

  # def create 
  # end

  def destroy
    session.delete :user_id
    user = nil
    redirect_to root_path
  end

  def omniauth
    data = request.env['omniauth.auth']

    user = User.find_by(uid: data[:uid], provider: data[:provider])
    if(!user)
      user = User.create do |u|
        u.uid =  data[:uid]
        u.provider = data[:provider]
        u.username = data[:info][:name]
        u.firstname = data[:info][:first_name]
        u.email = data[:info][:email]
        u.photo = data[:info][:image]
        u.admin = false
        # UserMailer.welcome_new_user_email(u).deliver_now
      end
      user.directories.create(name: "root", parent_id: nil)
    end

    if user.valid?

      #log them in
      session[:user_id] = user.id 
      session[:directory] = Directory.where(user_id: user.id, name: "root")[0].id

      if session[:store_location]
        redirect_to session[:store_location]
      else
        redirect_to logged_in_path
      end


      #send welcome email
    else
      redirect_to root_path 
    end
     
  end
end
