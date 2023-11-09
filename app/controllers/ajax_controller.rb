# frozen_string_literal: true

# Serves common AJAX requests.
class AjaxController < ApplicationController
  def counties
    @state = State.find_by(symbol: params[:state_symbol].upcase)
    render json: @state.counties
  end
end
