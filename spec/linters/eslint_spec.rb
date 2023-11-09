# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'eslint analysis' do
  subject(:report) { `yarn run lint` } # `lint` in `package.json` $.scripts.lint

  # Run `yarn run lint` to see the errors.
  # Run `yarn run lint_fix` to fix eslint errors.
  it 'has no offenses' do
    # Example success: Done in 1.00s.
    expect(report).to match(/Done in \d+\.\d+s\.\s$/)
  end
end
