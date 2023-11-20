# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :county

  validates :start_time, :end_time, presence: true
  validates :start_time, date: { after_or_equal_to: proc { Time.zone.now },
                                 message:           I18N.t('events.start_time_after_now') }
  validates :end_time, date: { after_or_equal_to: :start_time,
                               message:           I18N.t('events.end_time_after_start_time') }

  delegate :state, to: :county, allow_nil: true

  def county_names_by_id
    county&.state&.counties&.map { |c| [c.name, c.id] }.to_h || []
  end
end
