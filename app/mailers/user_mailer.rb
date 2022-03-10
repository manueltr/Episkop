class UserMailer < ApplicationMailer
    default from: 'episkop.emailer@gmail.com'

    def poll_invite_email(user, poll)
        @user = user
        @poll = poll
        mail(   to: @user.email, 
                subject: 'Episkop Poll Invite',
                body: 'Click this link to access the poll: http://localhost:3000/polls/' + @poll.invite_token + '/form')
    end

    def welcome_new_user_email(user)
        @user = user
        mail(   to: @user.email, 
                subject: 'Thanks for Joining Episkop!',
                body: 'Nice to meet you! Use our service to create and respond to polls.')
    end
end
