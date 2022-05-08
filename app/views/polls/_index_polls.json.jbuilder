json.polls(polls) do |poll|
    json.extract! poll, :id, :title, :summary, :opened, :ends_at, :created_at, :updated_at, :publish, :directory_id
    json.url poll_url(poll, format: :json)
    json.invite_token poll.invite_token
end