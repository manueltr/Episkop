class Poll < ApplicationRecord
    belongs_to :user

    #destroy all poll question if a poll is destroyed
    has_many :poll_questions, dependent: :destroy
    has_many :poll_answers, dependent: :destroy

    validates :title, :summary, presence: true
    validates :ends_at, presence: true, if: :publish?

    before_save :is_open

    def publish?
        self.publish
    end

    def is_open
        if self.publish
            self.opened = self.ends_at > Time.now.getutc
        end
    end

end
