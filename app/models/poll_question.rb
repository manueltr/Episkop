class PollQuestion < ApplicationRecord

    #associations
    belongs_to :poll
    has_one :user, through: :poll
    has_many :poll_answers, dependent: :destroy
    has_many :poll_votes, dependent: :destroy

    #validations
    validates :question_type, :content, presence: true

    #callbacks
    after_save :multiple_choice_answers


    def multiple_choice_answers
        if self.question_type == "Yes No"
            @question_answer = self.poll_answers.build(poll_id: self.poll_id)
            @question_answer.content = "Yes"
            @question_answer.save
            @question_answer = self.poll_answers.build(poll_id: self.poll_id)
            @question_answer.content = "No"
            @question_answer.save
        end
    end
            
end
