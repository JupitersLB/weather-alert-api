class TokensController < ApplicationController
  before_action :set_token, only: %i[update destroy]
  def create
    raise Token::AccessDenied if params[:user_id] != current_token.user_id

    user = User.find(params[:user_id])
    token = user.tokens.create(scopes: params[:scopes])
    render json: token
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'User does not exist' }, status: 404
  end

  def update
    raise Token::AccessDenied if params[:user_id] != current_token.user_id

    token.update(scopes: params[:scopes])
    render json: token
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Token does not exist' }, status: 404
  end

  def destroy
    raise Token::AccessDenied if params[:user_id] != current_token.user_id

    token.destroy!
    render json: { message: 'success' }, status: 200
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Token does not exist' }, status: 404
  end

  private

  def set_token
    token = Token.find_by!(user_id: params[:user_id], id: params[:id])
  end
end
