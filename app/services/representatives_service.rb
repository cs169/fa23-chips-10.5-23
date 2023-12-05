# frozen_string_literal: true

require 'google/apis/civicinfo_v2'

class RepresentativesService
  def self.fetch(address)
    service = Google::Apis::CivicinfoV2::CivicInfoService.new
    service.key = Rails.application.credentials[Rails.env.to_sym][:GOOGLE_API_KEY]
    begin
      result = service.representative_info_by_address(address: address)
    rescue Google::Apis::ClientError
      return nil
    end
    Representative.civic_api_to_representative_params(result)
  end
end
