# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    start_time { 1.day.from_now }
    end_time { 2.days.from_now }
    county
    name { 'Event Name' }
    description { 'Event Description' }
  end
end
