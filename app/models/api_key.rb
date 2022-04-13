class ApiKey < ApplicationRecord
    belongs_to :user
    has_secure_token :api_token
end
