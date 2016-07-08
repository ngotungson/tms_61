class Users::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    if current_user.present?
      flash[:success] = t "controller.session.success_signin"
      if current_user.supervisor?
        redirect_to supervisor_root_url
      elsif current_user.trainee?
        redirect_to root_url
      end
    else
      flash[:danger] = t "controller.session.error_signin"
      redirect_to new_user_session_url
    end
  end

  def destroy
    if current_user.present?
      sign_out(current_user)
      flash[:success] = t "controller.session.success_signout"
      redirect_to root_url
    end
  end
end
