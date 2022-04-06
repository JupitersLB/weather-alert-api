class WeathersController < ApplicationController
  skip_before_action :check_token_exists

  def forecast
    params.permit(:place_id) 
    if params[:place_id]
      response = GooglePlacesService.new(params[:place_id]).call
      location = response.body.dig('result', 'geometry', 'location')
      if location
        response = OpenWeatherService.new(lat: location['lat'], lng: location['lng']).call
        render json: response.body
      end
    end
  end
end
