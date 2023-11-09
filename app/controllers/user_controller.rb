# frozen_string_literal: true

class UserController < SessionController
  def profile
    @user = User.find(session[:current_user_id])
  end
end
