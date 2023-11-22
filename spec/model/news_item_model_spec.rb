# frozen_string_literal: true

require 'rails_helper'

describe NewsItem do
  describe '.find_for' do
    let(:representative) { create(:representative) }
    let(:news_item) { create(:news_item, link: 'fake_url', representative: representative) }

    it 'returns news items for a given representative' do
      news_item
      expect(described_class.find_for(representative.id).title).to eq('fake_title')
    end
  end
end
