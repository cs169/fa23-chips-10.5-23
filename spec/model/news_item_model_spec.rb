require 'rails_helper'

describe NewsItem do
  describe '.find_for' do
    let!(:representative) { create(:representative) }
    let!(:news_item) { create(:news_item, title: 'fake_title', link: 'fake_url', representative: representative) }
    it 'returns news items for a given representative' do
      expect(NewsItem.find_for(representative.id).title).to eq('fake_title')
    end
  end
end
