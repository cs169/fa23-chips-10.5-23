# frozen_string_literal: true

require 'rails_helper'

describe County do
  describe 'standardized FIPS' do
    it 'calls the model method where the result should add 0' do
      county = build(:county)
      expect(county.std_fips_code).to eq('001')
    end
  end
end
