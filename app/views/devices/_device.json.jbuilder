json.extract! device, :id, :token, :longitude, :latitude, :radius, :arn, :created_at, :updated_at
json.url device_url(device, format: :json)