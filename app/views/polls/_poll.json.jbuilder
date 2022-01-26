json.extract! poll, :id, :title, :summary, :opened, :ends_at, :created_at, :updated_at, :publish
json.url poll_url(poll, format: :json)
