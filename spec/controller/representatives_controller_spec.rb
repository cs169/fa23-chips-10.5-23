# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepresentativesController, type: :controller do
  describe 'GET #show' do
    context 'when a existing ID is provided' do
      let!(:representative_one) { create(:representative, id: 1) }

      before do
        get :show, params: { id: 1 }
      end

      it 'finds and sets the @representative correctly' do
        expect(assigns(:representative)).to eq(representative_one)
        expect(assigns(:representative).name).to eq 'Gavin Newsom'
        expect(assigns(:representative).political_party).to eq 'Democratic'
      end

      it 'successfully renders the show view' do
        expect(response).to render_template('show')
      end
    end

    context 'when a non-existing ID is provided' do
      it 'when id not found, flash warning' do
        get :show, params: { id: 999 }
        expect(assigns(:representative)).to be_nil
        expect(flash[:warning]).to eq 'id is not found, please enter a valid id.'
      end
    end
  end
end
