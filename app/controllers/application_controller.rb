class ApplicationController < ActionController::Base

  def forem_user
    current_owner
  end
  helper_method :forem_user


  def forem_admin?
    forem_user && forem_user.forem_admin?
  end
  helper_method :forem_admin?
  protect_from_forgery
end
