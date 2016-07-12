class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: :exception.message
  end

  def authenticate_supervisor!
    unless current_user.supervisor?
      flash[:danger] = t "controller.session.pleaseloginassupervisor"
      redirect_to new_user_session_url
    end
  end
end
