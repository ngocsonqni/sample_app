class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user.try(:authenticate, params[:session][:password])
      check_activated_email
    else
      flash.now[:danger] = t "invalid_email_password"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to static_pages_home_path
  end

  private

  def load_user
    @user = User.find_by email: params[:session][:email].downcase
    return if @user

    flash[:danger] = t "email_not_found"
    redirect_to login_path
  end

  def check_activated_email
    if @user.activated
      log_in @user
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash[:warning] = t "account_not_activated"
      redirect_to static_pages_home_path
    end
  end
end
