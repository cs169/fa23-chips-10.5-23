# frozen_string_literal: true

FactoryBot.define do
  factory :representative do
    title { 'Governor of California' }
    political_party { 'Democratic' }
    contact_address { 'California' }
    name { 'Gavin Newsom' }
  end
end
