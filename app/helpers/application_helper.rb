# frozen_string_literal: true

module ApplicationHelper
  def self.state_ids_by_name
    State.all.each_with_object({}) do |state, memo|
      memo[state.name] = state.id
    end.to_h
  end

  def self.state_symbols_by_name
    State.all.each_with_object({}) do |state, memo|
      memo[state.name] = state.symbol
    end
  end

  def self.nav_items
    [
      {
        title: 'Home',
        link:  Rails.application.routes.url_helpers.root_path
      },
      {
        title: 'Events',
        link:  Rails.application.routes.url_helpers.events_path
      },
      {
        title: 'Representatives',
        link:  Rails.application.routes.url_helpers.representatives_path
      }
    ]
  end

  def self.active(curr_controller_name, nav_link)
    nav_controller = Rails.application.routes.recognize_path(nav_link, method: :get)[:controller]
    return 'bg-primary-active' if curr_controller_name == nav_controller

    ''
  end
end
