class User < ApplicationRecord
    has_many :polls, dependent: :destroy
end
