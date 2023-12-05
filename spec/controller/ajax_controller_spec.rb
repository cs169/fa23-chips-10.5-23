# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AjaxController, type: :controller do
  let!(:state) { create(:state, symbol: 'TX') }
  let(:county_first) { create(:county, name: 'county_first', state: state) }
  let(:county_second) { create(:county, name: 'county_second', state: state) }

  describe 'GET #counties' do
    before do
      county_first
      county_second
    end

    context 'with a valid state symbol' do
      it 'returns a list of counties for the state' do \
        get :counties, params: { state_symbol: 'tx' }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response).to be_an_instance_of(Array)
        expect(json_response.length).to eq(2)
      end
    end
  end
end
