class UserMailer < ApplicationMailer
    default from: 'episkop.emailer@gmail.com'

    def welcome_email
        mail(   to: 'cnewby5283@tamu.edu', 
                subject: 'Thanks for Joining Episkop!',
                body: 'this is an invitation for a poll')
    end
end
