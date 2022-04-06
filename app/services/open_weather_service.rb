class OpenWeatherService
  def initialize(attributes = {})
    @lat = attributes[:lat]
    @lng = attributes[:lng]
    @api_key = ENV['OPEN_WEATHER_KEY']
  end

  def call
    base_url = "https://api.openweathermap.org/data/2.5/weather"
    url = "#{base_url}?lat=#{@lat}&lon=#{@lng}&units=metric&appid=#{@api_key}"
    response = weather_client.get(url)
  end

  def weather_client
    @_weather_client ||= Faraday.new do |builder|
      builder.adapter Faraday.default_adapter
      builder.response :json
    end
  end
end