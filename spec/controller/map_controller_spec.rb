# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MapController, type: :controller do
  describe 'GET #index' do
    before do
      @state1 = instance_double(State)
      @state2 = instance_double(State)
      allow(@state1).to receive(:std_fips_code).and_return(1)
      allow(@state2).to receive(:std_fips_code).and_return(2)
      @fake_results = [@state2, @state1]
      @fake_results_indexed = { 2 => @state2, 1 => @state1 }
    end

    it 'set up local variables successfully' do
      allow(State).to receive(:all).and_return(@fake_results)
      get :index
      expect(assigns(:states)).to eq(@fake_results)

      expect(assigns(:states_by_fips_code)).to eq @fake_results_indexed
      expect(State).to have_received(:all)
    end

    it 'render template successfully' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET #state' do
    before do
      @county1 = instance_double(County)
      @county2 = instance_double(County)
      allow(@county1).to receive(:std_fips_code).and_return(1)
      allow(@county2).to receive(:std_fips_code).and_return(2)
      @fake_results = [@county1, @county2]
      @fake_results_indexed = { 1 => @county1, 2 => @county2 }
      @state1 = instance_double(State)
      allow(@state1).to receive(:counties).and_return(@fake_results)
    end

    context 'when geting exist states' do
      before do
        allow(State).to receive(:find_by).with(symbol: 'KS').and_return(@state1)
      end

      it 'set up local variables successfully' do
        get :state, params: { state_symbol: 'KS' }
        expect(assigns(:state)).to eq(@state1)
        expect(assigns(:county_details)).to eq(@fake_results_indexed)
        expect(State).to have_received(:find_by).with(symbol: 'KS')
        expect(@state1).to have_received(:counties)
      end

      it 'render template successfully' do
        get :state, params: { state_symbol: 'KS' }
        expect(response).to render_template('state')
        expect(State).to have_received(:find_by).with(symbol: 'KS')
        expect(@state1).to have_received(:counties)
      end
    end

    it 'handle state not found' do
      allow(State).to receive(:find_by).with(symbol: 'QAQ').and_return(nil)
      get :state, params: { state_symbol: 'QAQ' }
      expect(assigns(:state)).to be_nil
      expect(response).to redirect_to root_path
    end
  end

  describe 'GET county' do
    let(:state_symbol) { 'CA' }
    let(:state) { instance_double(State, id: 1, counties: counties) }
    let(:county) { instance_double(County, name: 'Some County') }
    let(:counties) { instance_double(Array) }
    let(:representatives) { instance_double(Array) }

    before do
      allow(State).to receive(:find_by).with(symbol: state_symbol).and_return(state)
      allow(counties).to receive(:index_by).and_return('county_details')
      allow(RepresentativesService).to receive(:fetch).with(county.name).and_return(representatives)
    end

    context 'when state is found' do
      before do
        allow(controller).to receive(:get_requested_county).with(state.id).and_return(county)
        get :county, params: { state_symbol: state_symbol, std_fips_code: 0o01 }
      end

      it 'assigns @state' do
        expect(assigns(:state)).to eq(state)
      end

      it 'assigns @county' do
        expect(assigns(:county)).to eq(county)
      end

      it 'assigns @county_details' do
        expect(assigns(:county_details)).to eq('county_details')
      end

      it 'assigns @representatives' do
        expect(assigns(:representatives)).to eq(representatives)
      end
    end

    context 'when state is not found' do
      before do
        allow(State).to receive(:find_by).with(symbol: state_symbol).and_return(nil)
        get :county, params: { state_symbol: state_symbol, std_fips_code: 0o01 }
      end

      it 'handles state not found' do
        expect(assigns(:state)).to be_nil
      end
    end

    context 'when county is not found' do
      before do
        allow(controller).to receive(:get_requested_county).with(state.id).and_return(nil)
        get :county, params: { state_symbol: state_symbol, std_fips_code: 0o01 }
      end

      it 'handles county not found' do
        expect(assigns(:county)).to be_nil
      end
    end
  end
end
