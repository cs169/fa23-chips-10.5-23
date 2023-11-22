# frozen_string_literal: true

require 'google/apis/civicinfo_v2'

class SearchController < ApplicationController
  def search
		@representatives = RepresentativesService.fetch(params[:address])

    render 'representatives/search'
  end
end
