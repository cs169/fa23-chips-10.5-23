# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require_relative 'seed_data'

State.destroy_all
County.destroy_all
Representative.destroy_all

SeedData.states.each { |state| State.create state }

SeedData.states.each do |state|
    state = State.find_by(symbol: state[:symbol])
    county_filename = "lib/assets/counties_fips_data/#{state[:symbol].downcase}.json"
    File.open(Rails.root.join(county_filename), 'r:UTF-8') do |f|
        state.counties = JSON.parse(f.read, object_class: County)
    end
    state.save
end

SeedData.representatives.each do |rep|
    rep_model = Representative.create(name: rep[:name])
    rep[:news_items].each do |news_item|
        NewsItem.create(
            representative: rep_model,
            title:          news_item[:title],
            description:    news_item[:description],
            link:           news_item[:link]
        )
    end
end

SeedData.events.each do |event|
    state = State.find_by(symbol: event[:state_symbol])
    county = County.find_by(state_id: state.id, fips_code: event[:fips_code])
    Event.create(
        name:        event[:name],
        description: event[:description],
        county:      county,
        start_time:  event[:start_time],
        end_time:    event[:end_time]
    )
end
