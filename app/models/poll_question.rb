class PollQuestion < ApplicationRecord
    belongs_to :poll
    has_one :user, through: :polls
end
