# frozen_string_literal: true

class State < ApplicationRecord
  has_many :counties, inverse_of: :state, dependent: :delete_all

  # Standardized FIPS code eg. 06 for 6.
  def std_fips_code
    fips_code.to_s.rjust(2, '0')
  end
end
