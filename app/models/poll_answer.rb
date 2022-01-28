class PollAnswer < ApplicationRecord
    belongs_to :poll_question
    belongs_to :poll
    
    #validations
    validates :content, presence: true
end
