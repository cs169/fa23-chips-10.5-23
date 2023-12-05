# frozen_string_literal: true

FactoryBot.define do
  factory :state do
    sequence(:name) { |n| "State #{n}" }
    symbol { 'CA' }
    is_territory { 1 }
    lat_min { 1 }
    lat_max { 1 }
    long_min { 1 }
    long_max { 1 }
    sequence(:fips_code) { |n| n }
  end
end
