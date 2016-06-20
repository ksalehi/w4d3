class SessionsController < ApplicationController
  before_action :require_no_user!, only: [:create, :new]

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])

    if @user.save
      log_in!(@user)
      redirect_to cats_url
    else
      render :new
    end

  end

  def destroy
    if current_user
      current_user.reset_session_token!
      self.session[:session_token] = nil
    end
    redirect_to new_session_url
  end
end
