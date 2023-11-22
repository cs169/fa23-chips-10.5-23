# frozen_string_literal: true

class SearchController < ApplicationController
  def search
    @representatives = RepresentativesService.fetch(params[:address])

    render 'representatives/search'
  end
end
