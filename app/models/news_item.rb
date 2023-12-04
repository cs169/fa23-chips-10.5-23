# frozen_string_literal: true

require 'news-api'

class NewsItem < ApplicationRecord
  belongs_to :representative
  has_many :ratings, dependent: :delete_all

  @news_api = News.new(Rails.application.credentials[Rails.env.to_sym][:NEWS_API_KEY])

  def self.find_for(representative_id)
    NewsItem.find_by(
      representative_id: representative_id
    )
  end

  def self.search_articles(rep_name, issue)
    # Get the issue
    issue = issue.split
    # issue = issue.map { |issue| '"' + issue + '"' } # Add '"' to issue search exact issue
    issue = issue.join('+')

    # Get the query
    query = "#{rep_name}+#{issue}"

    # Get the articles
    @news_api.get_everything(q: query, language: 'en', sortBy: 'relevancy', page: 1, pageSize: 5)

    # Return the articles
  end
end
