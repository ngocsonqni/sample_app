class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :load_user, except: %i(new create index)
  before_action :correct_user, only: %i(edit update)

  def show; end

  def new
    @user = User.new
  end

  def index
    @users = User.page params[:page]
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_email_activate"
      redirect_to static_pages_home_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      flash.now[:danger] = t "profile_update_false"
      render :edit
    end
  end

  def destroy
    if current_user.admin?
      if @user.destroy
        flash[:success] = t "user_deleted"
      else
        flash[:danger] = t "delete_fail"
      end
    else
      flash[:danger] = t "only_admin_can_delete_user"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name,
                                 :email, :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to static_pages_home_path
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_log_in"
    redirect_to login_url
  end

  def correct_user
    redirect_to(static_pages_home_path) unless current_user?(@user)
  end
end
