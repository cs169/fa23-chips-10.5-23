# frozen_string_literal: true

require 'rails_helper'

describe State do
  describe 'standardized FIPS' do
    let(:state) { create(:state, symbol: 'CA', fips_code: 1) }

    it 'calls the model method where the result should add 0' do
      expect(state.std_fips_code).to eq('01')
    end
  end
end
