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

    #callbacks
    before_save :is_closed?

    after_initialize do
        if self.new_record?
          # values will be available for new record forms.
          if self.publish == nil
            self.publish = true
          end
          if self.anonymous == nil
            self.anonymous = false
          end
          if self.show_results == nil
            self.show_results = true
          end
          if self.resubmits == nil
            self.resubmits = true
          end
          
        end
      end


    def publish?
        self.publish
    end

    def is_closed?

      # time difference only in central time zone later implementation (support differenet time zones -- needs implementation)
      self.opened = (self.publish && (self.ends_at == nil || self.ends_at.time > Time.now.in_time_zone("Central Time (US & Canada)").time))
      return (!self.publish || (self.ends_at != nil && self.ends_at.time < Time.now.in_time_zone("Central Time (US & Canada)").time))

    end

    def is_anonymous?
        return self.anonymous
    end

    def results_closed?
        return !self.show_results
    end

end
