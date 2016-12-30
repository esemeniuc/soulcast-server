json.extract! block, :id, :blocker_token, :blockee_token, :blocker_id, :blockee_id, :created_at, :updated_at
json.url block_url(block, format: :json)