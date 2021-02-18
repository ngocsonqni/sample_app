class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "email_with_pass_reset_instructions"
      redirect_to static_pages_home_path
    else
      flash.now[:danger] = t "email_not_found"
      render :new
    end
  end

  def update
    if user_params[:password].empty?
      flash.now[:warning] = t "please_enter_password"
      render :edit
    elsif @user.update user_params
      flash[:success] = t "password_updated"
      redirect_to login_path
    else
      render :edit
    end
  end

  private

  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    redirect_to static_pages_home_path
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end
end
