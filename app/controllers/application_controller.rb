class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_supervisor!
    unless current_user.supervisor?
      flash[:danger] = t "controller.session.pleaseloginassupervisor"
      redirect_to new_user_session_url
    end
  end
end
