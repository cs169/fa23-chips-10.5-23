# frozen_string_literal: true

require 'csv'

class StateFipsTaskHelper
  FIPS_DIR = 'lib/assets/counties_fips_data'
  def self.fips_csv_to_hash(csv_data)
    all_fields = %i[
      state_symbol state_fips_code
      fips_code name fips_class
    ]
    extract_fields = %i[name fips_code fips_class]
    filter = ->(k, _) { extract_fields.include?(k) }
    mapper = lambda { |row|
      filtered = row.to_hash.select(&filter)
      filtered[:name] = filtered[:name].titleize
      filtered
    }
    table = CSV.new(
      csv_data,
      headers: all_fields
    ).to_a
    table.map(&mapper)
  end

  # Fetch the list of counties per state and their respective fips data from census.gov website.
  def self.fetch_fips_data_for_state(state)
    # See: https://www.census.gov/library/reference/code-lists/ansi.html#par_statelist
    state_symbol = state[:symbol].downcase
    state_url = 'https://www2.census.gov/geo/docs/reference/codes/files' \
                "/st#{state[:fips_code]}_#{state_symbol}_cou.txt"

    Rails.logger.info "Fetched fips data for #{state_symbol} via #{state_url}"
    File.open(state_url)
    IO.popen(state_url)
    URI.parse(state_url).open
    # possible bug
    fips_csv_to_hash URI.parse(state_url).read
  end

  def self.update(state_fips_array, to_replace, replacement)
    state_fips_array.map do |county|
      county = replacement if county[:fips_code] == to_replace[:fips_code]
      county
    end
  end

  def self.alaska_update(ak_counties)
    # See: https://en.wikipedia.org/wiki/Kusilvak_Census_Area,_Alaska
    to_replace = {
      fips_code:  '270',
      name:       'Wade Hampton Census Area',
      fips_class: 'H5'
    }
    replacement = {
      fips_code:  '158',
      name:       'Kusilvak Census Area',
      fips_class: 'H5'
    }
    update(ak_counties, to_replace, replacement)
  end

  def self.south_dakota_update(sd_counties)
    # See: https://en.wikipedia.org/wiki/Oglala_Lakota_County,_South_Dakota
    to_replace = {
      fips_code:  '113',
      name:       'Shannon County',
      fips_class: 'H1'
    }
    replacement = {
      fips_code:  '102',
      name:       'Oglala Lakota County',
      fips_class: 'H1'
    }
    update(sd_counties, to_replace, replacement)
  end

  def self.virginia_update(va_counties)
    # Bedford City, VA is no longer an independent city.
    # https://en.wikipedia.org/wiki/Bedford,_Virginia
    # https://en.wikipedia.org/wiki/List_of_cities_and_counties_in_Virginia
    bedford = {
      fips_code:  '515',
      name:       'Bedford City',
      fips_class: 'C7'
    }
    va_counties.delete_if { |county| county[:fips_code] == bedford[:fips_code] }
  end
end
