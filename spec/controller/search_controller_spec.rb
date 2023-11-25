# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET search' do
    let(:address) { 'Some Address' }
    let(:service) { instance_double(Google::Apis::CivicinfoV2::CivicInfoService) }
    let(:result) { instance_double(String) }
    let(:rep) { instance_double(String) }

    before do
      allow(Rails.application.credentials).to receive(:[]).with(:test).and_return({ GOOGLE_API_KEY: 'fake_key' })
      allow(Google::Apis::CivicinfoV2::CivicInfoService).to receive(:new).and_return(service)
      allow(service).to receive(:key=)
      allow(service).to receive(:representative_info_by_address).with(address: address).and_return(result)
      allow(Representative).to receive(:civic_api_to_representative_params).with(result).and_return(rep)
      get :search, params: { address: address }
    end

    it 'assigns @representatives' do
      expect(assigns(:representatives)).to eq(rep)
    end

    it 'renders the search template' do
      expect(response).to render_template('representatives/search')
    end
  end

  describe 'Get Search with blank parameter' do
    let(:address) { '' }

    it 'input blank parameter' do
      get :search, params: { address: address }
      expect(response).to redirect_to(representatives_path)
    end
  end
end
