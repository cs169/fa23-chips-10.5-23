# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
    describe 'GET search' do
    let(:address) { 'Some Address' }
    let(:service) { instance_double(Google::Apis::CivicinfoV2::CivicInfoService) }
    let(:result) { double('result') }
    let(:representatives_params) { double('representatives_params') }

    before do
      allow(Rails.application.credentials).to receive(:[]).with(:test).and_return({ GOOGLE_API_KEY: 'fake_key' })
      allow(Google::Apis::CivicinfoV2::CivicInfoService).to receive(:new).and_return(service)
      allow(service).to receive(:key=)
      allow(service).to receive(:representative_info_by_address).with(address: address).and_return(result)
      allow(Representative).to receive(:civic_api_to_representative_params).with(result).and_return(representatives_params)

      get :search, params: { address: address }
    end

    it 'assigns @representatives' do
      expect(assigns(:representatives)).to eq(representatives_params)
    end

    it 'renders the search template' do
      expect(response).to render_template('representatives/search')
    end
  end
end
