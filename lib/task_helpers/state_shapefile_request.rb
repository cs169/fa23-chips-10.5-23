# frozen_string_literal: true

require_relative './topojson_task_helper'

class StateShapefileRequest
  # Directory containing publicly accessible topojson for each state.
  TOPOJSON_DIR = 'app/assets/topojson/states'

  # Directory containing geojson files for each state that are not available on the web.
  # Required for consistency checks.
  GEOJSON_DIR = 'tmp/geojson/states'

  # Directory containing the shapefiles for each state.
  SHPFILE_DIR = 'tmp/shp/states'

  attr_accessor :fetch_url, :zip_filename, :unzip_dir, :shp_filename, :topojson_filename, :geojson_filename

  def initialize(state)
    state_symbol = state[:symbol].downcase
    # Use cousub shapefiles then dissolve the subdivisions into their respective counties.
    # See: https://www2.census.gov/geo/tiger/GENZ2019/shp/
    @fetch_url = 'https://www2.census.gov/geo/tiger/GENZ2019/shp/' \
                 "cb_2019_#{state[:fips_code]}_cousub_500k.zip"
    @zip_filename = "#{StateShapefileRequest::SHPFILE_DIR}/#{state_symbol}.zip"
    @unzip_dir = "#{StateShapefileRequest::SHPFILE_DIR}/#{state_symbol}"
    @shp_filename = "#{@unzip_dir}/cb_2019_#{state[:fips_code]}_cousub_500k.shp"
    @topojson_filename = "#{StateShapefileRequest::TOPOJSON_DIR}/#{state_symbol}.topo.json"
    @geojson_filename = "#{StateShapefileRequest::GEOJSON_DIR}/#{state_symbol}.geo.json"
  end

  def cmd(output_format)
    output_file = TopojsonTaskHelper.output_file_for(self, output_format)
    program = Rails.root.join TopojsonTaskHelper::MAPSHAPER
    "#{program} -i #{Rails.root.join(@shp_filename)} -simplify 10% keep-shapes -dissolve COUNTYFP " \
      "-o format=#{output_format} #{output_file}"
  end
end
