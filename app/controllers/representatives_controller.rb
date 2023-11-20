# frozen_string_literal: true

class RepresentativesController < ApplicationController
  def index
    @representatives = Representative.all
  end
  
  def show
    @representative = Representative.find_by(params[:id])
    if @representative.nil?
      flash[:warning] = I18n.t(id_no_found)
      redirect Representative_index_path
    end
  end
end
