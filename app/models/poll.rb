class Poll < ApplicationRecord
    belongs_to :user

    #destroy all poll question if a poll is destroyed
    has_many :poll_questions, dependent: :destroy
end
