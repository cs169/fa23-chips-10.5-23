# frozen_string_literal: true

require 'csv'
require 'fileutils'
require 'open-uri'
require 'zip'

require_relative 'task_helper'

module TopojsonTaskHelper
  MAPSHAPER = 'node_modules/.bin/mapshaper'

  def self.output_file_for(request, output_format)
    Rails.root.join({
      geojson:  request.geojson_filename,
      topojson: request.topojson_filename
    }[output_format.to_sym])
  end

  def self.log_cmd_status(cmd, exit_status)
    {
      true  => -> { Rails.logger.info("ok: #{cmd}") },
      false => -> { Rails.logger.error("err: #{cmd}") && abort },
      nil   => -> { Rails.logger.error('mapshaper not found - ran `yarn install`') && abort }
    }[exit_status]
  end

  def self.convert_from_shpfile(request, output_format='topojson')
    raise ArgumentError, "invalid output format #{output_format}" unless
        %w[geojson topojson].include? output_format

    # Make sure `yarn install` ran.
    # https://github.com/mbloch/mapshaper
    # `-simplify 40%` retains 40% of the information.
    # `-dissolve COUNTYFP` merges the sub-counties polygon into a single county.
    Rails.logger.info "Converting shp into #{output_format}"
    command = request.cmd(output_format)
    exit_status = system(command)
    log_cmd_status(command, exit_status)
  end

  def self.unzip_shpfiles(request)
    Rails.logger.info "Unzipping shp file into #{request.unzip_dir}"
    TaskHelper.reinit_dir request.unzip_dir
    TaskHelper.extract_zip request.zip_filename, request.unzip_dir
  end

  # Download shp file for a specific state then generate topojson.
  def self.fetch_shapefile_for(request)
    zip_file = Rails.root.join(request.zip_filename)
    File.open(zip_file, 'wb') do |f|
      Rails.logger.info "Fetching shp file from #{request.fetch_url} into #{zip_file}"
      f.write(
        URI.parse(request.fetch_url)
              .read
      )
      unzip_shpfiles request

      # Note that we only serve topojson since it is a more lightweight wire format.
      convert_from_shpfile request, 'geojson'
      convert_from_shpfile request, 'topojson'
    end
  end
end
