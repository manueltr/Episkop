class Poll < ApplicationRecord
    belongs_to :user

    #destroy all poll question if a poll is destroyed
    has_many :poll_questions, dependent: :destroy

    validates_presence_of :id
    validates_presence_of :user_id
    validates_presence_of :title
    validates_presence_of :summary
    validates_presence_of :opened
    validates_presence_of :ends_at
    validates_presence_of :created_at
    validates_presence_of :updated_at
    validates_presence_of :publish
end
