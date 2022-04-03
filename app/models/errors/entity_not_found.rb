class EntityNotFound < WeatherAlertError
  def initialize(entity)
    @entity = entity
  end

  def http_status
    404
  end

  def code
    'not_found'
  end

  def message
    "#{@entity} does not exist"
  end

  def to_hash
    {
      message: message,
      code: code
    }
  end
end