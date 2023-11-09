# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    @events = if params['filter-by']
                filter_events
              else
                Event.all
              end
  end

  def show
    @event = Event.find(params[:id])
  end

  private

  def filter_events
    @state = State.find_by(symbol: params['state'].upcase)
    if params['filter-by'] == 'state-only'
      return Event.where(
        county: @state.counties
      )
    end

    @county = County.find_by(state_id: @state.id, fips_code: params['county'])
    Event.where(
      county: @county
    )
  end
end
