class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include PublicActivity::StoreController

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    redirect_to :back
  end
end
