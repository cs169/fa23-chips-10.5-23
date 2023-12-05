# frozen_string_literal: true

FactoryBot.define do
  factory :news_item do
    title { 'test' }
    link { 'test' }
    description { 'test' }
    issue { 'Free Speech' }
    representative
  end
end
