# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'json'

require_relative '../task_helpers/task_helper'
require_relative '../task_helpers/topojson_task_helper'
require_relative '../task_helpers/state_fips_task_helper'
require_relative '../task_helpers/state_consistency_checker'
require_relative '../../lib/task_helpers/state_shapefile_request'
require_relative '../../db/seed_data'

Rails.logger = Logger.new($stdout)
Rails.logger.level = Logger::INFO

namespace :states do
  desc 'Download shapefiles for each state and convert to topojson with boundaries for each county.'
  task counties_topojson: :environment do
    TaskHelper.reinit_dir StateShapefileRequest::SHPFILE_DIR
    TaskHelper.reinit_dir StateShapefileRequest::TOPOJSON_DIR
    TaskHelper.reinit_dir StateShapefileRequest::GEOJSON_DIR
    SeedData.states.each do |state|
      request = StateShapefileRequest.new(state)
      TopojsonTaskHelper.fetch_shapefile_for request
    end
  end

  desc "Download FIPS data for each state's counties."
  task fips: :environment do
    # Download to lib directory since the contents should not be served via Sprockets.
    TaskHelper.reinit_dir StateFipsTaskHelper::FIPS_DIR
    updates = {
      AK: StateFipsTaskHelper.method(:alaska_update),
      SD: StateFipsTaskHelper.method(:south_dakota_update),
      VA: StateFipsTaskHelper.method(:virginia_update)
    }
    SeedData.states.each do |state|
      fips_data = StateFipsTaskHelper.fetch_fips_data_for_state(
        state
      )
      fips_data = updates[state[:symbol].to_sym].call(fips_data)\
          if updates.has_key?(state[:symbol].to_sym)
      fips_data_filename = "#{StateFipsTaskHelper::FIPS_DIR}/#{state[:symbol].downcase}.json"
      Rails.logger.info "Writing FIPS data for #{state[:name]} to "\
                        " #{Rails.root.join(fips_data_filename)}"
      TaskHelper.write_json(
        fips_data_filename,
        fips_data
      )
    end
  end

  desc 'Check the consistency of data in geojson and FIPS dataset'
  task check_consistency: :environment do
    # Consistency checks needed otherwise the UI will break for some states.
    SeedData.states.each do |state|
      county_by_fips_code = StateConsistencyChecker.county_by_fips_code state
      geojson = StateConsistencyChecker.geojson_for state
      StateConsistencyChecker.check state, geojson, county_by_fips_code
    end
  end
end
