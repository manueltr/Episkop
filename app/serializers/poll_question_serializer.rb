class PollQuestionSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :api
end
