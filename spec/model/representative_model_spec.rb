# frozen_string_literal: true

require 'rails_helper'

# Refer ChatGPT
class HashWrap
  def initialize(hash)
    @hash = hash
  end

  def method_missing(name, *args, &block)
    @hash[name] || super
  end

  def respond_to_missing?(key, _include_private=false)
    return true if @hash.has_key?(key)

    false
  end
end
office =
  HashWrap.new(
    {
      name: 'test_office_name',
      division_id: 'test_division_ID',
      official_indices: [0]
    }
  )
official = HashWrap.new({ name: 'test_official_name' })
rep_info_test = { offices: [office], officials: [official] }
rep_info_test = HashWrap.new(rep_info_test)

describe Representative do
  describe 'insert with BLANK parameters' do
    it 'calls the model method that insert a representative but with BLANK parameters' do
      rep =
        described_class.civic_api_to_representative_params(HashWrap.new({}))
      expect(rep).to eq([])
    end
  end

  describe 'insert with BLANK offices' do
    it 'calls the model method that insert a representative but with BLANK offices' do
      rep =
        described_class.civic_api_to_representative_params(
          HashWrap.new({ offices: [], officials: [official] })
        )
      expect(rep).to eq([])
    end
  end

  describe 'insert with BLANK officials' do
    it 'calls the model method that insert a representative but with BLANK officials' do
      rep =
        described_class.civic_api_to_representative_params(
          HashWrap.new({ offices: [office], officials: [] })
        )
      expect(rep).to eq([])
    end
  end

  describe 'inserting a new representative' do
    it 'calls the model method that insert a new representative' do
      rep = described_class.civic_api_to_representative_params(rep_info_test)[0]
      expect(rep.name).to eq('test_official_name')
      expect(rep.ocdid).to eq('test_division_ID')
      expect(rep.title).to eq('test_office_name')
    end
  end

  describe 'inserting an existing representative' do
    it 'calls the model method that insert an existing representative' do
      rep = described_class.civic_api_to_representative_params(rep_info_test)
      expect(rep.count).to eq(1)
      rep = described_class.civic_api_to_representative_params(rep_info_test)
      expect(rep.count).to eq(1)
    end
  end
end
