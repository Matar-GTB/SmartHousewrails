json.extract! device, :id, :name, :description, :user_id, :created_at, :updated_at
json.url device_url(device, format: :json)
