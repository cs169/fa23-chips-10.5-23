# frozen_string_literal: true

require_relative './topojson_task_helper'
class NationalShapefileRequest
  # Directory containing publicly accessible topojson for each state.
  TOPOJSON_DIR = 'app/assets/topojson/national/states'

  # Directory containing geojson file of all states in the US.
  GEOJSON_DIR = 'tmp/geojson/national/states'

  # Directory containing the Shapefile of all states in the US.
  SHPFILE_DIR = 'tmp/shp/national/states'

  attr_accessor :fetch_url, :zip_filename, :unzip_dir, :shp_filename, :topojson_filename, :geojson_filename

  def initialize
    # See: https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.html
    @fetch_url = 'https://www2.census.gov/geo/tiger/GENZ2018/shp/cb_2018_us_state_500k.zip'
    @zip_filename = "#{NationalShapefileRequest::SHPFILE_DIR}/us-states.zip"
    @unzip_dir = "#{NationalShapefileRequest::SHPFILE_DIR}/us-states"
    @shp_filename = "#{@unzip_dir}/cb_2018_us_state_500k.shp"
    @topojson_filename = "#{NationalShapefileRequest::TOPOJSON_DIR}/us-states.topo.json"
    @geojson_filename = "#{NationalShapefileRequest::GEOJSON_DIR}/us-states.geo.json"
  end

  def cmd(output_format)
    output_file = TopojsonTaskHelper.output_file_for(self, output_format)
    program = Rails.root.join TopojsonTaskHelper::MAPSHAPER
    "#{program} -i #{Rails.root.join(@shp_filename)} -simplify 10% keep-shapes" \
      " -o format=#{output_format} #{output_file}"
  end
end
