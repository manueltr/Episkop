class Poll < ApplicationRecord
    belongs_to :user
    has_many :poll_questions
end
