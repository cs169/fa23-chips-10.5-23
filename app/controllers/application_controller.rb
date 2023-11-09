# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticated

  private

  def authenticated
    @authenticated = !session[:current_user_id].nil?
  end
end
