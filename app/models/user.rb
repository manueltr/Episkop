class User < ApplicationRecord
    has_many :directories, dependent: :destroy
    has_many :polls, dependent: :destroy
    has_many :poll_votes, dependent: :destroy
end
