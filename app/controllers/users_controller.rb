class UsersController < ApplicationController
  before_action :set_user, only: %i[update show destroy]
  skip_before_action :check_token_exists, only: :create

  def create
    user = User.create_with(name: params[:name]).create(email: params[:email])
    return render nothing: true, status: 400 unless user.valid?

    token = Token.create(scopes: %w[tokens:write users:owners])
    user.token = token
    render json: user.to_h.merge({ token: { id: token.id, value: token.value } })
  rescue ActiveRecord::RecordNotUnique
    render json: { message: "Can't create user. Already exists" }, status: 403
  rescue ActiveRecord::ActiveRecordError, ActiveModel::ForbiddenAttributesError => e
    render json: { message: "Can't create user. #{e.message}" }, status: 400
  end

  def update
    @user.update(params.permit(:name, :email))

    return render nothing: true, status: 400 unless @user.valid?

    render json: @user.to_h, status: :ok
  rescue ActiveRecord::ActiveRecordError, ActiveModel::ForbiddenAttributesError => e
    render json: { message: "Can't update User" }, status: 403
  end

  def destroy
    @user.destroy!
    render json: { message: 'success' }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'User does not exist' }, status: 403
  end

  def show
    @user = User.find(params[:id])
    render json: @user.to_h, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'User does not exist' }, status: 403
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
