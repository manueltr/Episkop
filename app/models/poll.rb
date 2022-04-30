class Poll < ApplicationRecord

    require "time"


    #associations
    belongs_to :user
    has_many :poll_questions, dependent: :destroy
    has_many :poll_answers, dependent: :destroy
    has_many :poll_votes, dependent: :destroy
    has_many :poll_graphs, dependent: :destroy
    has_secure_token :invite_token

    #validations
    validates :title, :summary, presence: true
    validates :ends_at, presence: true, if: :publish?

    #callbacks
    before_save :is_closed?


    def publish?
        self.publish
    end

    def is_closed?
        self.opened = (self.publish && self.ends_at > Time.now.getutc)
        return (!self.publish || self.ends_at < Time.now.getutc)
    end

    def is_anonymous?
        return true
    end

    def results_closed?
        return false
    end

end
