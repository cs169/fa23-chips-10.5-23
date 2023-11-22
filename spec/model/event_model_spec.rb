# frozen_string_literal: true

require 'rails_helper'
describe Event do
  describe '.county_names_by_id' do
    let(:state) { create(:state) }
    # byebug
    let(:counties) { create_list(:county, 3, state: state) }
    let(:event) { create(:event, county: counties.first) }
    let(:event_with_no_county) { create(:event, county: nil) }

    it 'returns a hash table with normal parameter' do
      expected_result = counties.to_h { |c| [c.name, c.id] }
      # byebug
      expect(event.county_names_by_id).to eq(expected_result)
    end

    it 'returns [] with unmatched parameter' do
      expected_result = counties.to_h { |c| [c.name, c.id] }
      # byebug
      expect(event.county_names_by_id).to eq(expected_result)
    end
  end
end
