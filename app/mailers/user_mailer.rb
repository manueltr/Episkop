class UserMailer < ApplicationMailer
    default from: 'episkop.emailer@gmail.com'

    def welcome_email(user)
        @user = user
        mail(   to: @user.email, 
                subject: 'Thanks for Joining Episkop!',
                body: 'this is an invitation for a poll')
    end
end
