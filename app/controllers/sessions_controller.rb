class SessionsController < ApplicationController
  def new; end

  def load_user
    @user = User.find_by email: params[:session][:email].downcase
  end

  def create
    load_user
    if @user.try(:authenticate, params[:session][:password])
      log_in @user
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_to @user
    else
      flash.now[:danger] = t("invalid_email_password")
      render :new
    end
  end

  def destroy
    log_out
    redirect_to static_page_home_path
  end
end
