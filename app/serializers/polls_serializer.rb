class PollsSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :sumamry, :opened, :ends_at, :created_at, :updated_at, :publish, :invite_token, :directory_id
end
