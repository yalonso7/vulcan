json.extract! repo, :id, :name, :repo_url, :repo_type, :created_at, :updated_at
json.url repo_url(repo, format: :json)
