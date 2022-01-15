json.extract! journal, :id, :req, :notes, :params, :token, :created_at, :updated_at
json.url journal_url(journal, format: :json)
