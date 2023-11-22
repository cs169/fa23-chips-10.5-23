# frozen_string_literal: true

FactoryBot.define do
  factory :news_item do
    title { 'fake_title' }
    representative
  end
end
