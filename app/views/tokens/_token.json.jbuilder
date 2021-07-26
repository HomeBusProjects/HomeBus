json.extract! token, :id, :token, :enabled, :created_at, :updated_at
json.url token_url(token, format: :json)
