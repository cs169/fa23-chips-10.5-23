# frozen_string_literal: true

require_relative '../task_helpers/national_shapefile_request'

Rails.logger = Logger.new($stdout)
Rails.logger.level = Logger::INFO
namespace :national do
  desc 'Download Shapefile describing US States and convert to topojson.'
  task states_topo: :environment do
    TaskHelper.reinit_dir NationalShapefileRequest::SHPFILE_DIR
    TaskHelper.reinit_dir NationalShapefileRequest::GEOJSON_DIR
    TaskHelper.reinit_dir NationalShapefileRequest::TOPOJSON_DIR
    request = NationalShapefileRequest.new
    TopojsonTaskHelper.fetch_shapefile_for request
  end
end
