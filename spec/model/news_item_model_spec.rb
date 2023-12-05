# frozen_string_literal: true

require 'rails_helper'

describe NewsItem do
  describe '.find_for' do
    let(:representative) { create(:representative) }
    let(:news_item) { create(:news_item, link: 'fake_url', representative: representative) }

    it 'returns news items for a given representative' do
      news_item
      expect(described_class.find_for(representative.id).title).to eq('test')
    end
  end

  describe '.search_articles' do
    it 'returns articles for a given representative and issue' do
      # Stub the News API
      news_api_double = instance_double(News)
      allow(news_api_double).to receive(:get_everything).and_return('articles')
      allow(described_class).to receive(:news_api).and_return(news_api_double)

      # Call the method
      expect(described_class.search_articles('rep_name', 'issue')).to eq('articles')
    end
  end
end
