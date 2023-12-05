# frozen_string_literal: true

class SearchController < ApplicationController
  def search
    if params[:address].blank?
      flash[:warning] = I18n.t('representatives.blank_location_input')
      redirect_to representatives_path
      return
    end
    @representatives = RepresentativesService.fetch(params[:address])
    if @representatives.nil?
      flash[:warning] = I18n.t('representatives.invalid_location_input')
      redirect_to representatives_path
      return
    end
    render 'representatives/search'
  end
end
