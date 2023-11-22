# frozen_string_literal: true

FactoryBot.define do
  factory :state do
    name { 'California' }
    symbol { 'Cal' }
    is_territory { 1 }
    lat_min { 1 }
    lat_max { 1 }
    long_min { 1 }
    long_max { 1 }
    fips_code { 1 }
  end
end
