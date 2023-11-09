# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'haml-lint analysis' do
  subject(:report) { `bundle exec haml-lint` }

  # Unfortunately, as of this writing haml-lint does not yet have auto-correct functionality.
  # See: https://github.com/sds/haml-lint/issues/217
  # Run `bundle exec haml-lint` to see the errors.
  it 'has no offenses' do
    expect(report).to match(/\s\d+ files? inspected, 0 lints detected\s$/)
  end
end
