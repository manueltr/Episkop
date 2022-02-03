class UserMailer < ApplicationMailer
    deault from 'episkop.emailer@gmail.com'

    def welcome_email
        mail(to: 'cnewby5283@tamu.edu', subject: 'Thanks for Joining Episkop!')
    end
end
