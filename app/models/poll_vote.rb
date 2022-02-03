class PollVote < ApplicationRecord

    #associations
    belongs_to :user
    belongs_to :poll
    belongs_to :poll_question
    belongs_to :poll_answer, optional: true

end
