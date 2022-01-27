class PollQuestion < ApplicationRecord
    belongs_to :poll
    has_one :user, through: :polls

    validates :question_type, :content, presence: true
end
