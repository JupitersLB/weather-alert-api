class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :check_token_exists

  rescue_from Token::AccessDenied, with: :render_error_response

  attr_reader :current_token

  private

  def check_token_exists
    authenticate_or_request_with_http_token do |token, _options|
      @current_token = Token.find_by(value: token)
      raise Token::AccessDenied unless @current_token

      @current_token
    end
  end

  def render_error_response(exception)
    render json: { message: exception.message, code: exception.code }, status: exception.http_status
  end
end
