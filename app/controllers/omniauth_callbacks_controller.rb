class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :authenticate_user!

  def all
    p env["omniauth.auth"]
    user = User.from_omniauth env["omniauth.auth"], current_user
    if user.persisted?
      flash[:success] = t "controller.session.success_signin"
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to root_url
    end
  end

  def failure
    super
  end


  alias_method :facebook, :all
  alias_method :twitter, :all
  alias_method :google_oauth2, :all
end
