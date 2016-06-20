class UsersController < ApplicationController
  before_action :require_no_user!


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in!(@user)
      redirect_to cats_url
    else
      render :new
    end
  end




  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
