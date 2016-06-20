class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Allows us to access the current_user method/object in our views
  helper_method :current_user

  def require_no_user!
    redirect_to cats_url if current_user
  end

  def current_user
    return nil if self.session[:session_token].nil?
    @user ||= User.find_by(:session_token => self.session[:session_token])
  end

  def log_in!(user)
    user.reset_session_token!
    self.session[:session_token] = user.session_token
  end

  def validate_cat_is_yours
    cat = Cat.find(cat_params[:id])
    unless current_user.cats.include?(cat)
      redirect_to cats_url
      errors.add(:not_yours, "this is not your cat")
    end
  end
end
