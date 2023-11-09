# frozen_string_literal: true

class StateConsistencyChecker
  def self.geojson_for(state)
    # NOTE: make sure to run `bundle exec rails states:counties_topojson` first.
    state_request = StateShapefileRequest.new state
    geojson = nil
    File.open(Rails.root.join(state_request.geojson_filename), 'r:UTF-8') do |f|
      geojson = JSON.parse(
        f.read
      )
    end
    geojson
  end

  def self.county_by_fips_code(state)
    # NOTE: make sure to run `bundle exec rails states:fips` first.
    fips_filename = "#{StateFipsTaskHelper::FIPS_DIR}/#{state[:symbol].downcase}.json"
    fips_data = {}
    File.open(Rails.root.join(fips_filename), 'r:UTF-8') do |f|
      fips_data = JSON.parse(
        f.read,
        object_class: County
      )
    end
    fips_data.index_by(&:std_fips_code)
  end

  def self.check(state, geojson, county_by_fips_code)
    log_check state, geojson, county_by_fips_code
    geojson['features'].each do |feature_entry|
      county_fips_code = feature_entry['properties']['COUNTYFP']
      err = "County code #{county_fips_code} not found in #{state[:symbol]} FIPS dataset."
      raise ArgumentError, err unless county_by_fips_code.has_key? county_fips_code
    end
  end

  def self.log_check(state, geojson, county_by_fips_code)
    Rails.logger.info "#{state[:symbol]} has #{geojson['features'].length} geojson entries"\
                      " and #{county_by_fips_code.length} FIPS entries."
    raise ArgumentError, 'Geojson and FIPS dataset counties mismatch' \
        if geojson['features'].length != county_by_fips_code.length
  end
end
