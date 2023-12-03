# frozen_string_literal: true

FactoryBot.define do
  factory :county do
    name { 'Berkeley' }
    state
    fips_code { 1 }
    fips_class { 1 }
  end
end
