class Poll < ApplicationRecord

    #associations
    belongs_to :user
    has_many :poll_questions, dependent: :destroy
    has_many :poll_answers, dependent: :destroy
    has_many :poll_votes, dependent: :destroy
    has_secure_token :invite_token

    #validations
    validates :title, :summary, presence: true
    validates :ends_at, presence: true, if: :publish?

    #callbacks
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
