class PollAnswer < ApplicationRecord
    belongs_to :poll_question
    belongs_to :poll
    has_many :poll_votes, dependent: :destroy
    
    #validations
    validates :content, presence: true
end
