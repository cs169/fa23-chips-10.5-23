# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'rubocop analysis' do
  subject(:report) { `bundle exec rubocop` }

  # Run `bundle exec rubocop -a` to auto-correct some linter errors
  it 'has no offenses' do
    expect(report).to match(/no offenses detected$/)
  end
end
