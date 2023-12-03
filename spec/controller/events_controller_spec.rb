# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:state) { create(:state, symbol: 'CA') }
  let(:state_a) { create(:state, symbol: 'AK') }
  let(:county) { create(:county, state: state, fips_code: '003') }
  let!(:event_ca) { create(:event, county: county) }
  let!(:event_ak) { create(:event, county: create(:county, state: state_a, fips_code: '005')) }

  describe 'GET #index' do
    context 'without filters' do
      it 'returns all events' do
        get :index
        expect(assigns(:events)).to contain_exactly(event_ca, event_ak)
      end
    end

    context 'with state filter' do
      it 'returns events from specified state' do
        get :index, params: { 'filter-by': 'state-only', state: 'CA' }
        expect(assigns(:events)).to contain_exactly(event_ca)
      end
    end

    context 'with county filter' do
      it 'returns events from the specified county' do
        get :index, params: { 'filter-by': 'county', state: 'CA', county: '003' }
        expect(assigns(:events)).to contain_exactly(event_ca)
      end
    end
  end

  describe 'GET #show' do
    it 'assigns requested event to @event' do
      get :show, params: { id: event_ca.id }
      expect(assigns(:event)).to eq(event_ca)
    end
  end
end
