# frozen_string_literal: true

class RepresentativesController < ApplicationController
  def index
    @representatives = Representative.all
  end

  def show
    @representative = Representative.find_by(id: params[:id])
    return unless @representative.nil?

    flash[:warning] = I18n.t('representatives.id_no_found')
    redirect_to representatives_path
    nil
  end
end
