json.extract! device, :id, :token, :latitude, :longitude, :radius, :created_at, :updated_at
json.url device_url(device, format: :json)