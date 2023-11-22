# frozen_string_literal: true

class MapController < ApplicationController
  # Render the map of the United States.
  def index
    @states = State.all
    @states_by_fips_code = @states.index_by(&:std_fips_code)
  end

  # Render the map of the counties of a specific state.
  def state
    @state = State.find_by(symbol: params[:state_symbol].upcase)
    handle_state_not_found && return if @state.nil?

    @county_details = @state.counties.index_by(&:std_fips_code)
  end

  # Render the map of a specific county.
  def county
    @state = State.find_by(symbol: params[:state_symbol].upcase)
    handle_state_not_found && return if @state.nil?

    @county = get_requested_county @state.id
    handle_county_not_found && return if @state.nil?

    @county_details = @state.counties.index_by(&:std_fips_code)

    service = Google::Apis::CivicinfoV2::CivicInfoService.new
    service.key = Rails.application.credentials[Rails.env.to_sym][:GOOGLE_API_KEY]
    address = @county.name
    result = service.representative_info_by_address(address: address)
    @representatives = Representative.civic_api_to_representative_params(result)
  end

  private

  def handle_state_not_found
    state_symbol = params[:state_symbol].upcase
    redirect_to root_path, alert: "State '#{state_symbol}' not found."
  end

  def handle_county_not_found
    state_symbol = params[:state_symbol]
    std_fips_code = params[:std_fips_code]
    redirect_to root_path, alert: "County with code '#{std_fips_code}' not found for #{state_symbol}"
  end

  def get_requested_county(state_id)
    County.find_by(
      state:     state_id,
      fips_code: params[:std_fips_code].to_i(10)
    )
  end
end
