# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name { 'Event Name' } # 你可以生成随机或特定的事件名
    description { 'Event Description' } # 事件描述
    association :county # 这假设你有一个对应的 county factory
    start_time { 1.day.from_now } # 事件开始时间，例如从现在起的1天后
    end_time { 2.days.from_now } # 事件结束时间，例如从现在起的2天后
  end
end
