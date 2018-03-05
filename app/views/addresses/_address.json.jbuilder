json.extract! address, :id, :street, :street2, :city, :state, :zip_code, :lat,
              :lng, :created_at, :updated_at
json.url address_url(address, format: :json)
