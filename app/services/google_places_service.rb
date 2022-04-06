class GooglePlacesService
  def initialize(place_id)
    @place_id = place_id
    @api_key = ENV['GOOGLE_PLACES_KEY']
  end

  def call
    base_url = "https://maps.googleapis.com/maps/api/place/details/json"
    url = "#{base_url}?place_id=#{@place_id}&fields=geometry&key=#{@api_key}"
    response = places_client.get(url)
  end

  def places_client
    @_places_client ||= Faraday.new do |builder|
      builder.adapter Faraday.default_adapter
      builder.response :json
    end
  end
end