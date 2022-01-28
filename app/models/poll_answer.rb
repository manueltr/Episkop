class PollAnswer < ApplicationRecord
    belongs_to :poll_question
    belongs_to :poll
end
